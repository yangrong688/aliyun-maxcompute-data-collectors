# Copyright 1999-2019 Alibaba Group Holding Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


import argparse
import csv
import os
import re
import sys
import time

from utils import print_utils
from migration_runner import MigrationRunner


def parse_table_mapping(table_mapping_path):
    def parse_line(line: str):
        try:
            colon_idx = line.index(":")
        except ValueError as e:
            raise Exception("Cannot parse line: " + line)

        hive, mc = line[: colon_idx], line[colon_idx + 1:]

        try:
            dot_idx = hive.index(".")
        except ValueError as e:
            raise Exception("Cannot parse line: " + line)
        hive_db, hive_tbl = hive[: dot_idx].strip(), hive[dot_idx + 1:].strip()

        # parse partition spec
        hive_part_spec = ""
        m = re.search(r'.*\((.*)\)', hive_tbl)
        if m is not None:
            hive_part_spec = m.group(1)
            hive_tbl = hive_tbl[: -len(hive_part_spec) - 2]

        # parse table config
        table_config = ""
        table_macher = re.search(r'.*\{(.*)\}', hive_tbl)
        if table_macher is not None:
            table_config = table_macher.group(1)
            hive_tbl = hive_tbl[: -len(table_config) - 2]

        try:
            dot_idx = mc.index(".")
        except ValueError as e:
            raise Exception("Cannot parse line: " + line)
        mc_pjt, mc_tbl = mc[: dot_idx].strip(), mc[dot_idx + 1:].strip()

        # TODO: partition column in partition spec could be in upper case
        return (hive_db.lower(),
                hive_tbl.lower(),
                hive_part_spec,
                table_config,
                mc_pjt.lower(),
                mc_tbl.lower())

    table_mapping = {}
    db_mapping = {}
    with open(table_mapping_path, "r") as fd:
        for line in fd.readlines():
            (hive_db, hive_tbl, hive_part_spec, table_config, mc_pjt, mc_tbl) = parse_line(line)

            if (hive_db, hive_tbl, hive_part_spec, table_config) in table_mapping:
                raise Exception("Duplicated table mapping: " + line)
            if hive_db in db_mapping and db_mapping[hive_db] != mc_pjt:
                raise Exception("A Hive database is mapped to "
                                "multiple MaxCompute project: " + line)

            table_mapping[(hive_db, hive_tbl, hive_part_spec, table_config)] = (mc_pjt, mc_tbl)
            db_mapping[hive_db] = mc_pjt
    return table_mapping


def parse_hive_row_count_file(hive_row_count_file_path):
    def _get_partition_values(partition_spec: str):
        res = []
        entries = partition_spec.split("/")
        for entry in entries:
            kv = entry.split("=")
            res.append(kv[1])
        return "/".join(res)

    def _parse_row(row):
        if row is None or row == '':
            return

        db = row[0].strip().lower()
        tbl = row[1].strip().lower()
        if row[3] == '':
            count = row[2]
            hive_row_count_data_non_partitioned["%s.%s" % (db, tbl)] = int(count)
        else:
            partition_spec = row[3]
            partition_values = _get_partition_values(partition_spec)
            count = row[5]
            if "%s.%s" % (db, tbl) not in hive_row_count_data_partitioned:
                hive_row_count_data_partitioned["%s.%s" % (db, tbl)] = {}
            hive_row_count_data_partitioned["%s.%s" % (db, tbl)][partition_values] = int(count)

    if not os.path.isfile(hive_row_count_file_path):
        raise Exception("Hive row count file path is invalid")

    # for partitioned tables: {db.table -> {partition spec -> count}}
    # for non-partitioned tables: {db.table -> count}
    hive_row_count_data_non_partitioned = {}
    hive_row_count_data_partitioned = {}

    with open(hive_row_count_file_path, 'r', newline='') as fd:
        reader = csv.reader(fd)

        # skip header
        reader.__next__()

        for row in reader:
            _parse_row(row)

    return hive_row_count_data_non_partitioned, hive_row_count_data_partitioned


def validate_arguments(args):
    # validate arguments
    if args.hms_thrift_addr is None:
        print_utils.print_red("Must specify --hms_thrift_addr\n")
        sys.exit(1)

    if args.datasource is None:
        args.datasource = "Hive"
    elif args.datasource != "Hive" and args.datasource != "OSS":
        print_utils.print_red("Datasource can only be Hive or OSS")
        sys.exit(1)

    if args.mode == "SINGLE":
        should_exit = False
        if args.hive_db is None:
            print_utils.print_red("Must specify --hive_db in SINGLE mode\n")
            should_exit = True
        if args.hive_table is None:
            print_utils.print_red("Must specify --hive_table in SINGLE mode\n")
            should_exit = True
        if args.mc_project is None:
            print_utils.print_red("Must specify --mc_project in SINGLE mode\n")
            should_exit = True
        if args.mc_table is None:
            print_utils.print_red("Must specify --mc_table in SINGLE mode\n")
            should_exit = True
        if should_exit:
            sys.exit(1)
    elif args.mode == "BATCH":
        should_exit = False
        if args.table_mapping is None:
            print_utils.print_red("Must specify --table_mapping in BATCH mode\n")
            should_exit = True
        if should_exit:
            sys.exit(1)
    else:
        print_utils.print_red(
            "Invalid mode value, available values are SINGLE and BATCH\n")
        sys.exit(1)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Run odps-data-carrier')
    parser.add_argument(
        "--hms_thrift_addr",
        required=True,
        type=str,
        help="Thrift address of Hive metastore.")
    parser.add_argument(
        "--mode",
        required=False,
        default="SINGLE",
        type=str,
        help="""Migration mode, SINGLE or BATCH. SINGLE means migrating one Hive table to 
        MaxCompute, BATCH means migrating all the Hive tables specified by the table mapping 
        file""")
    parser.add_argument(
        "--metasource",
        required=False,
        help="Specify metadata source, should be a meta-carrier's output")
    parser.add_argument(
        "--datasource",
        required=False,
        default="Hive",
        help="Specify datasource, can be Hive or OSS")
    parser.add_argument(
        "--validate_only",
        required=False,
        const=True,
        action="store_const",
        default=False,
        help="Only run data validation on specified tables")

    # single mode arguments
    parser.add_argument(
        "--hive_db",
        required=False,
        type=str,
        help="Specify Hive database in SINGLE mode")
    parser.add_argument(
        "--hive_table",
        required=False,
        type=str,
        help="Specify Hive table in SINGLE mode")
    parser.add_argument(
        "--mc_project",
        required=False,
        type=str,
        help="Specify MaxCompute project in SINGLE mode")
    parser.add_argument(
        "--mc_table",
        required=False,
        type=str,
        help="Specify MaxCompute table in SINGLE mode")

    # batch mode arguments
    parser.add_argument(
        "--parallelism",
        required=False,
        default=5,
        type=int,
        help="Max parallelism of migration jobs")
    parser.add_argument(
        "--table_mapping",
        required=False,
        type=str,
        help="""The path of table mapping from Hive to MaxCompute in BATCH mode. Lines of the file 
        should be formatted as follows: <hive db>.<hive tbl>:<mc project>.<mc tbl>""")
    parser.add_argument(
        "--dynamic_scheduling",
        required=False,
        const=True,
        action="store_const",
        default=False,
        help="Turn on dynamic scheduling")
    parser.add_argument(
        "--threshold",
        required=False,
        default=10,
        type=int,
        help="""When dynamic scheduling is on, jobs will be submitted if the number of running job
        is less than the threshold""")
    parser.add_argument(
        "--append",
        required=False,
        const=True,
        action="store_const",
        default=False,
        help="Instead of overwrite table, append to it")
    parser.add_argument(
        "--num_of_partitions",
        required=False,
        type=str,
        help="""The partitions number of partitioned table split from Hive to MaxCompute in BATCH mode. """)
    parser.add_argument(
        "--failover_failed_file",
        required=False,
        type=str,
        help="""Rerun the failed tables list in failover_file. """)
    parser.add_argument(
        "--failover_success_file",
        required=False,
        type=str,
        help="""Rerun the failed tables list in failover_file. """)
    parser.add_argument(
        "--name",
        required=False,
        type=str,
        help="""name of this migration job, by default is a timestamp"""
    )
    parser.add_argument(
        "--hive_meta_file",
        required=False,
        type=str
    )

    # optional arguments
    parser.add_argument(
        "--verbose",
        required=False,
        const=True,
        action="store_const",
        default=False,
        help="Print detailed information")

    args = parser.parse_args()
    validate_arguments(args)

    bin_dir = os.path.dirname(os.path.realpath(__file__))
    odps_data_carrier_dir = os.path.dirname(bin_dir)

    table_mapping = {}
    if args.mode == "SINGLE":
        table_mapping = {(args.hive_db.lower(), args.hive_table.lower(), "", ""):
                         (args.mc_project.lower(), args.mc_table.lower())}
    else:
        table_mapping = parse_table_mapping(args.table_mapping)

    num_of_partitions = 0
    if (args.num_of_partitions is not None):
        num_of_partitions = args.num_of_partitions

    failover_failed_file = None
    failover_success_file = None
    if args.failover_failed_file is not None and args.failover_success_file is not None:
        print_utils.print_red("Only support one failover file! Check failover_failed_file and " +
                              "failover_success_file can not both be specified.")
        sys.exit(1)
    elif args.failover_failed_file is not None:
        failover_failed_file = args.failover_failed_file
    elif args.failover_success_file is not None:
        failover_success_file = args.failover_success_file

    name = str(int(time.time()))
    if args.name is not None:
        name = args.name
    migration_runner = MigrationRunner(odps_data_carrier_dir,
                                       table_mapping,
                                       args.hms_thrift_addr,
                                       args.datasource,
                                       args.verbose,
                                       num_of_partitions,
                                       failover_failed_file,
                                       failover_success_file,
                                       name)
    if args.dynamic_scheduling:
        migration_runner.set_dynamic_scheduling()
        migration_runner.set_threshold(args.threshold)
    if args.metasource is not None:
        migration_runner.set_metasource(args.metasource)
    if args.validate_only:
        migration_runner.set_validate_only()
    if args.append:
        migration_runner.set_append()
    if args.hive_meta_file is not None:
        hive_meta_non_partitioned, hive_meta_partitioned = parse_hive_row_count_file(
            args.hive_meta_file)
        migration_runner.set_hive_meta_non_partitioned(hive_meta_non_partitioned)
        migration_runner.set_hive_meta_partitioned(hive_meta_partitioned)
    migration_runner.set_parallelism(args.parallelism)

    try:
        migration_runner.run()
    finally:
        migration_runner.stop()