import fileinput
import sys
import re
import json
import argparse

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

json_data=open(args.config_file)
config = json.load(json_data)
json_data.close()

paths = {}

# Make changes in src/CMakeLists.txt
paths['CMakeLists'] = args.source + "/src/CMakeLists.txt"

daemon_name_re = re.compile(r"#(set_property\(TARGET daemon PROPERTY OUTPUT_NAME) \"\S+\"\)", re.IGNORECASE)
for line in fileinput.input([paths['CMakeLists']], inplace=True):
	line = daemon_name_re.sub("\\1 \"%s\")" % config['core']['daemon_name'], line)
	# sys.stdout is redirected to the file
	sys.stdout.write(line)


# Make changes in src/cryptonote_config.h
paths['cryptonote_config'] = args.source + "/src/cryptonote_config.h"

CRYPTONOTE_NAME_re = re.compile(r"(#define CRYPTONOTE_NAME)", re.IGNORECASE)
P2P_DEFAULT_PORT_re = re.compile(r"(#define P2P_DEFAULT_PORT)", re.IGNORECASE)
RPC_DEFAULT_PORT_re = re.compile(r"(#define RPC_DEFAULT_PORT)", re.IGNORECASE)
P2P_STAT_TRUSTED_PUB_KEY_re = re.compile(r"(#define P2P_STAT_TRUSTED_PUB_KEY)\s+\"\w+\"", re.IGNORECASE)
CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX_re = re.compile(r"(#define CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX)", re.IGNORECASE)
MONEY_SUPPLY_re = re.compile(r"(#define MONEY_SUPPLY)", re.IGNORECASE)
if 'EMISSION_SPEED_FACTOR' in config['core']:
	EMISSION_SPEED_FACTOR_re =re.compile(r"(#define EMISSION_SPEED_FACTOR)\s+\(\d+\)", re.IGNORECASE)
if 'DIFFICULTY_TARGET' in config['core']:
	DIFFICULTY_TARGET_re = re.compile(r"(#define DIFFICULTY_TARGET)\s+\d+", re.IGNORECASE)
COIN_re = re.compile(r"(#define COIN)", re.IGNORECASE)
CRYPTONOTE_DISPLAY_DECIMAL_POINT_re = re.compile(r"(#define CRYPTONOTE_DISPLAY_DECIMAL_POINT)", re.IGNORECASE)
MINIMUM_FEE_re = re.compile(r"(#define DEFAULT_FEE)", re.IGNORECASE)
CRYPTONOTE_MINED_MONEY_UNLOCK_WINDOW_re = re.compile(r"(#define CRYPTONOTE_MINED_MONEY_UNLOCK_WINDOW)", re.IGNORECASE)
if 'CRYPTONOTE_BLOCK_GRANTED_FULL_REWARD_ZONE' in config['core']:
	CRYPTONOTE_BLOCK_GRANTED_FULL_REWARD_ZONE_re = re.compile(r"(#define CRYPTONOTE_BLOCK_GRANTED_FULL_REWARD_ZONE)\s+\d+", re.IGNORECASE)
genesisCoinbaseTxHex_re = re.compile(r"(#define GENESIS_COINBASE_TX_HEX)\s+\"\w*\"", re.IGNORECASE)

for line in fileinput.input([paths['cryptonote_config']], inplace=True):
	line = CRYPTONOTE_NAME_re.sub("\\1 \"%s\"" % config['core']['CRYPTONOTE_NAME'], line)
	line = P2P_DEFAULT_PORT_re.sub("\\1 %s" % config['core']['P2P_DEFAULT_PORT'], line)
	line = RPC_DEFAULT_PORT_re.sub("\\1 %s" % config['core']['RPC_DEFAULT_PORT'], line)
	line = CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX_re.sub("\\1 %s" % config['core']['CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX'], line)

	if 'P2P_STAT_TRUSTED_PUB_KEY' in config['core']:
		line = P2P_STAT_TRUSTED_PUB_KEY_re.sub("\\1 \"%s\"" % config['core']['P2P_STAT_TRUSTED_PUB_KEY'], line)
	else:
		line = P2P_STAT_TRUSTED_PUB_KEY_re.sub("\\1 \"%s\"" % "", line)
	if 'MONEY_SUPPLY' in config['core']:
		line = MONEY_SUPPLY_re.sub("\\1 %s" % config['core']['MONEY_SUPPLY'], line)
	else:
		line = MONEY_SUPPLY_re.sub("\\1 %s" % "static_cast<uint64_t>(-1)", line)
	if 'EMISSION_SPEED_FACTOR' in config['core']:
		line = EMISSION_SPEED_FACTOR_re.sub("\\1 (%s)" % config['core']['EMISSION_SPEED_FACTOR'], line)
	if 'DIFFICULTY_TARGET' in config['core']:
		line = DIFFICULTY_TARGET_re.sub("\\1 %s" % config['core']['DIFFICULTY_TARGET'], line)
	if 'COIN' in config['core']:
		line = COIN_re.sub("\\1 %s" % config['core']['COIN'], line)
	else:
		line = COIN_re.sub("\\1 %s" % "100000000", line)
	if 'CRYPTONOTE_DISPLAY_DECIMAL_POINT' in config['core']:
		line = CRYPTONOTE_DISPLAY_DECIMAL_POINT_re.sub("\\1 %s" % config['core']['CRYPTONOTE_DISPLAY_DECIMAL_POINT'], line)
	else:
		line = CRYPTONOTE_DISPLAY_DECIMAL_POINT_re.sub("\\1 %s" % "8", line)
	if 'MINIMUM_FEE' in config['core']:
		line = MINIMUM_FEE_re.sub("\\1 %s" % config['core']['MINIMUM_FEE'], line)
	else:
		line = MINIMUM_FEE_re.sub("\\1 %s" % "1000000", line)
	if 'CRYPTONOTE_MINED_MONEY_UNLOCK_WINDOW' in config['core']:
		line = CRYPTONOTE_MINED_MONEY_UNLOCK_WINDOW_re.sub("\\1 %s" % config['core']['CRYPTONOTE_MINED_MONEY_UNLOCK_WINDOW'], line)
	else:
		line = CRYPTONOTE_MINED_MONEY_UNLOCK_WINDOW_re.sub("\\1 %s" % "10", line)
	if 'CRYPTONOTE_BLOCK_GRANTED_FULL_REWARD_ZONE' in config['core']:
		line = CRYPTONOTE_BLOCK_GRANTED_FULL_REWARD_ZONE_re.sub("\\1 %s" % config['core']['CRYPTONOTE_BLOCK_GRANTED_FULL_REWARD_ZONE'], line)

	line = genesisCoinbaseTxHex_re.sub("\\1 \"%s\";" % config['core']['genesisCoinbaseTxHex'], line)

	# sys.stdout is redirected to the file
	sys.stdout.write(line)


CHECKPOINTS_re = re.compile(r"(const CheckpointData\s+CHECKPOINTS\[\] = {)[^;]+(};)", re.DOTALL)
cryptonote_config_file = open(paths['cryptonote_config'],'r')
cryptonote_config_content = cryptonote_config_file.read()
cryptonote_config_file.close()
if 'CHECKPOINTS' in config['core']:
	cryptonote_config_content = CHECKPOINTS_re.sub("\\1 %s \\2" % config['core']['CHECKPOINTS'], cryptonote_config_content)
else:
	cryptonote_config_content = CHECKPOINTS_re.sub("\\1 %s \\2" % "", cryptonote_config_content)
cryptonote_config_file = open(paths['cryptonote_config'], "w")
cryptonote_config_file.write(cryptonote_config_content)
cryptonote_config_file.close()


# Make changes in src/p2p/p2p_networks.h
paths['p2p_networks'] = args.source + "/src/p2p/p2p_networks.h"

BYTECOIN_NETWORK_re = re.compile(r"(const static boost::uuids::uuid CRYPTONOTE_NETWORK =) { {[^;]+} };", re.IGNORECASE)
for line in fileinput.input(paths['p2p_networks'], inplace=True):
	line = BYTECOIN_NETWORK_re.sub("\\1 { { %s} };" % config['core']['BYTECOIN_NETWORK'], line)
	# sys.stdout is redirected to the file
	sys.stdout.write(line)


# Make changes in src/p2p/net_node.inl
paths['p2p_net_node'] = args.source + "/src/p2p/net_node.inl"
BYTECOIN_SEEDS_re = re.compile(r"(\/\/ADD_HARDCODED_SEED_NODE\([^\)]+\);)", re.IGNORECASE)
for line in fileinput.input(paths['p2p_net_node'], inplace=True):
	for seed in config['core']['SEED_NODES']:
		line = BYTECOIN_SEEDS_re.sub("\\1\n      ADD_HARDCODED_SEED_NODE(\"%s\");" % seed, line)
	# sys.stdout is redirected to the file
	sys.stdout.write(line)

