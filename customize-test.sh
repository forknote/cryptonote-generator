#! /usr/bin/env bash


# Bash script for change coin files

# Exit immediately if an error occurs, or if an undeclared variable is used
set -o errexit

[ "$OSTYPE" != "win"* ] || die "Install Cygwin to use on Windows"

# Set directory vars
. "vars.cfg"

# Set config vars
. libs/ticktick.sh
CONFIG=`cat $1`

# File
tickParse "$CONFIG"

daemon_name=``daemon_name``
CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX=``CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX``
P2P_DEFAULT_PORT=``P2P_DEFAULT_PORT``
RPC_DEFAULT_PORT=``RPC_DEFAULT_PORT``
MAX_BLOCK_SIZE_INITIAL=``MAX_BLOCK_SIZE_INITIAL``
CRYPTONOTE_NAME=``CRYPTONOTE_NAME``
UPGRADE_HEIGHT=``UPGRADE_HEIGHT``
P2P_STAT_TRUSTED_PUB_KEY=``P2P_STAT_TRUSTED_PUB_KEY``
SEED_NODES=``SEED_NODES``
CHECKPOINTS=``CHECKPOINTS``
genesisCoinbaseTxHex=``genesisCoinbaseTxHex``
BYTECOIN_NETWORK=``BYTECOIN_NETWORK``


FILE_CMakeLists=$(<${TEMP_PATH}"/src/CMakeLists.txt")
# Test daemon name change
if [[ ${FILE_CMakeLists} == *set_property\(TARGET\ daemon\ PROPERTY\ OUTPUT_NAME*${daemon_name}* ]]
then
	echo "TEST PASSED - Daemon name change"
else
	echo "TEST FAILED - Daemon name change"
	exit 2
fi
FILE_CMakeLists=""

FILE_cryptonote_config=$(<${TEMP_PATH}"/src/cryptonote_config.h")
# Test CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX
if [[ ${FILE_cryptonote_config} == *const\ uint64_t\ *CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX*\=*${CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX}* ]]
then
	echo "TEST PASSED - CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX change"
else
	echo "TEST FAILED - CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX change"
	exit 2
fi

# Test P2P_DEFAULT_PORT
if [[ ${FILE_cryptonote_config} == *const\ int\ *P2P_DEFAULT_PORT\ *\=\ *${P2P_DEFAULT_PORT}* ]]
then
	echo "TEST PASSED - P2P_DEFAULT_PORT change"
else
	echo "TEST FAILED - P2P_DEFAULT_PORT change"
	exit 2
fi

# Test RPC_DEFAULT_PORT
if [[ ${FILE_cryptonote_config} == *const\ int\ *RPC_DEFAULT_PORT\ *\=\ *${RPC_DEFAULT_PORT}* ]]
then
	echo "TEST PASSED - RPC_DEFAULT_PORT change"
else
	echo "TEST FAILED - RPC_DEFAULT_PORT change"
	exit 2
fi


# The following test does not work with the json parser.
# * is not parsed correctly

# Test MAX_BLOCK_SIZE_INITIAL
MAX_BLOCK_SIZE_INITIAL=${MAX_BLOCK_SIZE_INITIAL//[\*]/\\\*}
echo ${MAX_BLOCK_SIZE_INITIAL}
exit 1
#if [[ ${FILE_cryptonote_config} == *const\ size_t\ *MAX_BLOCK_SIZE_INITIAL\ *\=\ *${MAX_BLOCK_SIZE_INITIAL}* ]]
#then
#	echo "TEST PASSED - MAX_BLOCK_SIZE_INITIAL change"
#else
#	echo "TEST FAILED - MAX_BLOCK_SIZE_INITIAL change"
#	exit 2
#fi

# Test CRYPTONOTE_NAME
if [[ ${FILE_cryptonote_config} == *const\ char\ *CRYPTONOTE_NAME\[\]\ *=\ *\"${CRYPTONOTE_NAME}\"* ]]
then
	echo "TEST PASSED - CRYPTONOTE_NAME change"
else
	echo "TEST FAILED - CRYPTONOTE_NAME change"
	exit 2
fi

# Test UPGRADE_HEIGHT
if [[ ${FILE_cryptonote_config} == *const\ uint64_t\ *UPGRADE_HEIGHT\ *=\ *${UPGRADE_HEIGHT}* ]]
then
	echo "TEST PASSED - UPGRADE_HEIGHT change"
else
	echo "TEST FAILED - UPGRADE_HEIGHT change"
	exit 2
fi

# Test P2P_STAT_TRUSTED_PUB_KEY
if [[ ${FILE_cryptonote_config} == *const\ char\ *P2P_STAT_TRUSTED_PUB_KEY\[\]\ *\=\ *\"${P2P_STAT_TRUSTED_PUB_KEY}\"* ]]
then
	echo "TEST PASSED - P2P_STAT_TRUSTED_PUB_KEY change"
else
	echo "TEST FAILED - P2P_STAT_TRUSTED_PUB_KEY change"
	exit 2
fi

# Test SEED_NODES
if [[ ${FILE_cryptonote_config} == *const\ char\*\ *const\ *SEED_NODES\[\]\ *\=\ *{\ *${SEED_NODES}\ *}\;* ]]
then
	echo "TEST PASSED - SEED_NODES change"
else
	echo "TEST FAILED - SEED_NODES change"
	exit 2
fi

# Test CHECKPOINTS
if [[ ${FILE_cryptonote_config} == *${CHECKPOINTS}* ]]
then
	echo "TEST PASSED - CHECKPOINTS change"
else
	echo "TEST FAILED - CHECKPOINTS change"
	exit 2
fi
FILE_cryptonote_config=""

FILE_Currency=$(<${TEMP_PATH}"/src/cryptonote_core/Currency.cpp")
# Test genesisCoinbaseTxHex
if [[ ${FILE_Currency} == *std::string\ genesisCoinbaseTxHex\ *\=\ *\"${genesisCoinbaseTxHex}\"* ]]
then
	echo "TEST PASSED - genesisCoinbaseTxHex change"
else
	echo "TEST FAILED - genesisCoinbaseTxHex change"
	exit 2
fi
FILE_Currency=""


FILE_p2p_networks=$(<${TEMP_PATH}"/src/p2p/p2p_networks.h")
# Test BYTECOIN_NETWORK
if [[ ${FILE_p2p_networks} == *const\ static\ boost::uuids::uuid\ BYTECOIN_NETWORK\ *\=\ *{\ {\ ${BYTECOIN_NETWORK}}\ }* ]]
then
	echo "TEST PASSED - BYTECOIN_NETWORK change"
else
	echo "TEST FAILED - BYTECOIN_NETWORK change"
	exit 2
fi
FILE_p2p_networks=""

