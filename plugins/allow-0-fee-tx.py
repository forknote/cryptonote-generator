# Cryptonote core:  Bytecoin
# Allows users to create coins with 0 fee transactions

import fileinput
import sys
import re
import json
import argparse
import textwrap
import os
import shutil

parser = argparse.ArgumentParser()

parser.add_argument('--config', action='store', dest='config_file',
                    default='config.json',
                    help='Configuration filename. Format: json'
                    )
parser.add_argument('--source', action='store', dest='source',
                    default='tmp',
                    help='Working folder containing the base coin source'
                    )
args = parser.parse_args()

json_data = open(args.config_file)
config = json.load(json_data)
json_data.close()

paths = {}
source_paths = {}


### START Allow 0 fee transactions
# Make changes in src/cryptonote_core/cryptonote_core.cpp
paths['cryptonote_core_cpp'] = args.source + "/src/cryptonote_core/cryptonote_core.cpp"
for line in fileinput.input([paths['cryptonote_core_cpp']], inplace=True):
    if "if (amount_in <= amount_out) {" in line:
        line = "  if (amount_in < amount_out) {\n"
    # sys.stdout is redirected to the file
    sys.stdout.write(line)


### 1 CHECK LESS
# Make changes in src/cryptonote_core/tx_pool.cpp
paths['tx_pool_cpp'] = args.source + "/src/cryptonote_core/tx_pool.cpp"
for line in fileinput.input([paths['tx_pool_cpp']], inplace=True):
    if "if (outputs_amount >= inputs_amount) {" in line:
        line = "    if (outputs_amount > inputs_amount) {\n"
    if "if (inputsValid && fee > 0)" in line:
        line = "    if (inputsValid)\n"
    # sys.stdout is redirected to the file
    sys.stdout.write(line)
### END Allow 0 fee transactions