# Cryptonote core:  Bytecoin
# Adds print-genesis-tx function to the daemon

import fileinput
import sys
import re
import json
import argparse
import textwrap

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

####
# Text added to src/daemon/daemon.cpp
# Add checkpoint command line ability
daemon_text_1 = textwrap.dedent("""\
  const command_line::arg_descriptor<bool>        arg_print_genesis_tx = { "print-genesis-tx", "Prints genesis' block tx hex to insert it to config and exits" };
    """)
daemon_text_2 = textwrap.dedent("""\
command_line::add_arg(desc_cmd_sett, arg_print_genesis_tx);
    """)
daemon_text_3 = textwrap.dedent("""\
    if (command_line::get_arg(vm, arg_print_genesis_tx)) {
      print_genesis_tx_hex(logManager);
      return false;
    }
    """)
daemon_text_4 = textwrap.dedent("""\
  try {
    currencyBuilder.currency();
  } catch (std::exception&) {
    std::cout << "GENESIS_COINBASE_TX_HEX constant has an incorrect value. Please launch: " << CryptoNote::CRYPTONOTE_NAME << "d --" << arg_print_genesis_tx.name;
    return 1;
  }
    """)
daemon_text_5 = textwrap.dedent("""\
void print_genesis_tx_hex(LoggerManager& logManager) {
  CryptoNote::Transaction tx = CryptoNote::CurrencyBuilder(logManager).generateGenesisTransaction();
  CryptoNote::blobdata txb = tx_to_blob(tx);
  std::string tx_hex = blobToHex(txb);

  std::cout << "Insert this line into your coin configuration file as is: " << std::endl;
  std::cout << "const char GENESIS_COINBASE_TX_HEX[] = " << tx_hex << ";" << std::endl;

  return;
}
    """)

# Make changes in src/daemon/daemon.cpp
paths['daemon'] = args.source + "/src/daemon/daemon.cpp"

for line in fileinput.input([paths['daemon']], inplace=True):
    if "arg_testnet_on  = {" in line:
        sys.stdout.write(daemon_text_1)
    sys.stdout.write(line)
    if "command_line::add_arg(desc_cmd_sett, arg_testnet_on);" in line:
        sys.stdout.write(daemon_text_2)
    if "currencyBuilder.testnet(testnet_mode);" in line:
        sys.stdout.write(daemon_text_4)
    if "bool command_line_preprocessor(const boost::program_options::variables_map& vm, LoggerRef& logger);" in line:
        sys.stdout.write(daemon_text_5)
    if "po::notify(vm);" in line:
        sys.stdout.write(daemon_text_3)

# Text added to src/cryptonote_core/Currency.h
# Text added to src/cryptonote_core/Currency.cpp
currency_h_text_1 = textwrap.dedent("""\
    Transaction generateGenesisTransaction();
    """)
currency_cpp_text_1 = textwrap.dedent("""\
   Transaction CurrencyBuilder::generateGenesisTransaction() {
    CryptoNote::Transaction tx;
    CryptoNote::AccountPublicAddress ac = boost::value_initialized<CryptoNote::AccountPublicAddress>();
    m_currency.constructMinerTx(0, 0, 0, 0, 0, ac, tx); // zero fee in genesis

    return tx;
  }

    """)

paths['currency_h'] = args.source + "/src/cryptonote_core/Currency.h"
for line in fileinput.input([paths['currency_h']], inplace=True):
    if "CurrencyBuilder& maxBlockNumber(uint64_t val) { m_currency.m_maxBlockHeight = val; return *this; }" in line:
        sys.stdout.write(currency_h_text_1)
    sys.stdout.write(line)

paths['currency_cpp'] = args.source + "/src/cryptonote_core/Currency.cpp"
for line in fileinput.input([paths['currency_cpp']], inplace=True):
    if "CurrencyBuilder& CurrencyBuilder::emissionSpeedFactor(unsigned int val) {" in line:
        sys.stdout.write(currency_cpp_text_1)
    sys.stdout.write(line)
