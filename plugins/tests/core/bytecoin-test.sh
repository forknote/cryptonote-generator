#! /usr/bin/env bash


# Bash script for change coin files

# Exit immediately if an error occurs, or if an undeclared variable is used
set -o errexit

[ "$OSTYPE" != "win"* ] || die "Install Cygwin to use on Windows"

# Set directory vars
. "vars.cfg"

# Set config vars
. "lib/ticktick.sh"
CONFIG=`cat $1`

# File
tickParse "$CONFIG"


# src/CMakeLists.txt
FILE_CMakeLists=$(<${TEMP_PATH}"/src/CMakeLists.txt")

# Test daemon name change
daemon_name=``core.daemon_name``
if [[ ${FILE_CMakeLists} == *set_property\(TARGET\ daemon\ PROPERTY\ OUTPUT_NAME*${daemon_name}* ]]
then
	echo "TEST PASSED - Daemon name change"
else
	echo "TEST FAILED - Daemon name change"
	exit 2
fi

FILE_CMakeLists=""


# src/cryptonote_config.h
FILE_cryptonote_config=$(<${TEMP_PATH}"/src/cryptonote_config.h")

# Test CRYPTONOTE_NAME
CRYPTONOTE_NAME=``core.CRYPTONOTE_NAME``
if [[ ${FILE_cryptonote_config} == *const\ char\ *CRYPTONOTE_NAME\[\]\ *=\ *\"${CRYPTONOTE_NAME}\"* ]]
then
	echo "TEST PASSED - CRYPTONOTE_NAME change"
else
	echo "TEST FAILED - CRYPTONOTE_NAME change"
	exit 2
fi

# Test CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX
CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX=``core.CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX``
if [[ ${FILE_cryptonote_config} == *const\ uint64_t\ *CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX*\=*${CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX}* ]]
then
	echo "TEST PASSED - CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX change"
else
	echo "TEST FAILED - CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX change"
	exit 2
fi

# Test P2P_DEFAULT_PORT
P2P_DEFAULT_PORT=``core.P2P_DEFAULT_PORT``
if [[ ${FILE_cryptonote_config} == *const\ int\ *P2P_DEFAULT_PORT\ *\=\ *${P2P_DEFAULT_PORT}* ]]
then
	echo "TEST PASSED - P2P_DEFAULT_PORT change"
else
	echo "TEST FAILED - P2P_DEFAULT_PORT change"
	exit 2
fi

# Test RPC_DEFAULT_PORT
RPC_DEFAULT_PORT=``core.RPC_DEFAULT_PORT``
if [[ ${FILE_cryptonote_config} == *const\ int\ *RPC_DEFAULT_PORT\ *\=\ *${RPC_DEFAULT_PORT}* ]]
then
	echo "TEST PASSED - RPC_DEFAULT_PORT change"
else
	echo "TEST FAILED - RPC_DEFAULT_PORT change"
	exit 2
fi

# Test P2P_STAT_TRUSTED_PUB_KEY
P2P_STAT_TRUSTED_PUB_KEY=``core.P2P_STAT_TRUSTED_PUB_KEY``
if [[ ${FILE_cryptonote_config} == *const\ char\ *P2P_STAT_TRUSTED_PUB_KEY\[\]\ *\=\ *\"${P2P_STAT_TRUSTED_PUB_KEY}\"* ]]
then
	echo "TEST PASSED - P2P_STAT_TRUSTED_PUB_KEY change"
else
	echo "TEST FAILED - P2P_STAT_TRUSTED_PUB_KEY change"
	exit 2
fi

# Test SEED_NODES
SEED_NODES=``core.SEED_NODES``
if [[ ${FILE_cryptonote_config} == *const\ char\*\ *const\ *SEED_NODES\[\]\ *\=\ *{\ *${SEED_NODES}\ *}\;* ]]
then
	echo "TEST PASSED - SEED_NODES change"
else
	echo "TEST FAILED - SEED_NODES change"
	exit 2
fi

# Test CHECKPOINTS
CHECKPOINTS=``core.CHECKPOINTS``
if [[ ${FILE_cryptonote_config} == *${CHECKPOINTS}* ]]
then
	echo "TEST PASSED - CHECKPOINTS change"
else
	echo "TEST FAILED - CHECKPOINTS change"
	exit 2
fi


# Test UPGRADE_HEIGHT
UPGRADE_HEIGHT=``core.UPGRADE_HEIGHT``
UPGRADE_HEIGHT=${UPGRADE_HEIGHT:-1}
if [[ ${FILE_cryptonote_config} == *const\ uint64_t\ *UPGRADE_HEIGHT\ *=\ *${UPGRADE_HEIGHT}* ]]
then
	echo "TEST PASSED - UPGRADE_HEIGHT change"
else
	echo "TEST FAILED - UPGRADE_HEIGHT change"
	exit 2
fi

# MONEY_SUPPLY
MONEY_SUPPLY=``core.MONEY_SUPPLY``
if [ -n "$MONEY_SUPPLY" ]; then
if [[ ${FILE_cryptonote_config} == *const\ uint64_t\ *MONEY_SUPPLY\ *=\ *${MONEY_SUPPLY}\;* ]]; then
	echo "TEST PASSED - MONEY_SUPPLY change"
else
	echo "TEST FAILED - MONEY_SUPPLY change"
	exit 2
fi
fi

# EMISSION_SPEED_FACTOR
EMISSION_SPEED_FACTOR=``core.EMISSION_SPEED_FACTOR``
if [ -n "$EMISSION_SPEED_FACTOR" ]; then
if [[ ${FILE_cryptonote_config} == *const\ unsigned\ *EMISSION_SPEED_FACTOR\ *=\ *${EMISSION_SPEED_FACTOR}* ]]; then
	echo "TEST PASSED - EMISSION_SPEED_FACTOR change"
else
	echo "TEST FAILED - EMISSION_SPEED_FACTOR change"
	exit 2
fi
fi

# DIFFICULTY_TARGET
DIFFICULTY_TARGET=``core.DIFFICULTY_TARGET``
if [ -n "$DIFFICULTY_TARGET" ]; then
if [[ ${FILE_cryptonote_config} == *const\ uint64_t\ *DIFFICULTY_TARGET\ *=\ *${DIFFICULTY_TARGET}* ]]; then
	echo "TEST PASSED - DIFFICULTY_TARGET change"
else
	echo "TEST FAILED - DIFFICULTY_TARGET change"
	exit 2
fi
fi

# COIN
COIN=``core.COIN``
if [ -n "$COIN" ]; then
if [[ ${FILE_cryptonote_config} == *const\ uint64_t\ *COIN\ *=\ *UINT64_C\(\ ${COIN}\)* ]]; then
	echo "TEST PASSED - COIN change"
else
	echo "TEST FAILED - COIN change"
	exit 2
fi
fi

# CRYPTONOTE_DISPLAY_DECIMAL_POINT
CRYPTONOTE_DISPLAY_DECIMAL_POINT=``core.CRYPTONOTE_DISPLAY_DECIMAL_POINT``
if [ -n "$CRYPTONOTE_DISPLAY_DECIMAL_POINT" ]; then
if [[ ${FILE_cryptonote_config} == *const\ size_t\ *CRYPTONOTE_DISPLAY_DECIMAL_POINT\ *=\ *${CRYPTONOTE_DISPLAY_DECIMAL_POINT}* ]]; then
	echo "TEST PASSED - CRYPTONOTE_DISPLAY_DECIMAL_POINT change"
else
	echo "TEST FAILED - CRYPTONOTE_DISPLAY_DECIMAL_POINT change"
	exit 2
fi
fi

# MINIMUM_FEE
MINIMUM_FEE=``core.MINIMUM_FEE``
if [ -n "$MINIMUM_FEE" ]; then 
if [[ ${FILE_cryptonote_config} == *const\ uint64_t\ *MINIMUM_FEE\ *=\ *UINT64_C\(\ ${MINIMUM_FEE}\)* ]]; then
	echo "TEST PASSED - MINIMUM_FEE change"
else
	echo "TEST FAILED - MINIMUM_FEE change"
	exit 2
fi
fi

# DEFAULT_DUST_THRESHOLD
DEFAULT_DUST_THRESHOLD=``core.DEFAULT_DUST_THRESHOLD``
if [ -n "$DEFAULT_DUST_THRESHOLD" ]; then
if [[ ${FILE_cryptonote_config} == *const\ uint64_t\ *DEFAULT_DUST_THRESHOLD\ *=\ *UINT64_C\(\ ${DEFAULT_DUST_THRESHOLD}\)* ]]; then
	echo "TEST PASSED - DEFAULT_DUST_THRESHOLD change"
else
	echo "TEST FAILED - DEFAULT_DUST_THRESHOLD change"
	exit 2
fi
fi

# The following test does not work with the json parser.
# * is not parsed correctly

# Test MAX_BLOCK_SIZE_INITIAL
MAX_BLOCK_SIZE_INITIAL=``core.MAX_BLOCK_SIZE_INITIAL``
#if [[ ${FILE_cryptonote_config} == *const\ size_t\ *MAX_BLOCK_SIZE_INITIAL\ *\=\ *${MAX_BLOCK_SIZE_INITIAL}* ]]
#then
#	echo "TEST PASSED - MAX_BLOCK_SIZE_INITIAL change"
#else
#	echo "TEST FAILED - MAX_BLOCK_SIZE_INITIAL change"
#	exit 2
#fi

FILE_cryptonote_config=""


# src/cryptonote_core/Currency.cpp
FILE_Currency=$(<${TEMP_PATH}"/src/cryptonote_core/Currency.cpp")

# Test genesisCoinbaseTxHex
genesisCoinbaseTxHex=``core.genesisCoinbaseTxHex``
if [[ ${FILE_Currency} == *std::string\ genesisCoinbaseTxHex\ *\=\ *\"${genesisCoinbaseTxHex}\"* ]]
then
	echo "TEST PASSED - genesisCoinbaseTxHex change"
else
	echo "TEST FAILED - genesisCoinbaseTxHex change"
	exit 2
fi
FILE_Currency=""


# src/p2p/p2p_networks.h
FILE_p2p_networks=$(<${TEMP_PATH}"/src/p2p/p2p_networks.h")

# Test BYTECOIN_NETWORK
BYTECOIN_NETWORK=``core.BYTECOIN_NETWORK``
if [[ ${FILE_p2p_networks} == *const\ static\ boost::uuids::uuid\ BYTECOIN_NETWORK\ *\=\ *{\ {\ ${BYTECOIN_NETWORK}}\ }* ]]
then
	echo "TEST PASSED - BYTECOIN_NETWORK change"
else
	echo "TEST FAILED - BYTECOIN_NETWORK change"
	exit 2
fi

FILE_p2p_networks=""

