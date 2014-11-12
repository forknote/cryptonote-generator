#! /usr/bin/env bash


# Bash script for change coin files

# Exit immediately if an error occurs, or if an undeclared variable is used
set -o errexit
set -o nounset

[ "$OSTYPE" != "win"* ] || die "Install Cygwin to use on Windows"

# Set directory vars
. "vars.cfg"

# Set config vars
. "config-loader.sh" $1

FILE_CMakeLists=$(<${TEMP_PATH}"/src/CMakeLists.txt")
# Test daemon name change
if [[ ${FILE_CMakeLists} == *set_property\(TARGET\ daemon\ PROPERTY\ OUTPUT_NAME*${daemon_name}* ]]
then
	echo "TEST PASSED - Daemon name change"
else
	echo "TEST FAILED - Daemon name change"
	TESTS_PASSED=0
fi
FILE_CMakeLists=""

FILE_cryptonote_config=$(<${TEMP_PATH}"/src/cryptonote_config.h")
# Test CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX
if [[ ${FILE_cryptonote_config} == *const\ uint64_t\ *CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX*\=*${CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX}* ]]
then
	echo "TEST PASSED - CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX change"
else
	echo "TEST FAILED - CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX change"
	TESTS_PASSED=0
fi

# Test P2P_DEFAULT_PORT
if [[ ${FILE_cryptonote_config} == *const\ int\ *P2P_DEFAULT_PORT\ *\=\ *${P2P_DEFAULT_PORT}* ]]
then
	echo "TEST PASSED - P2P_DEFAULT_PORT change"
else
	echo "TEST FAILED - P2P_DEFAULT_PORT change"
	TESTS_PASSED=0
fi

# Test RPC_DEFAULT_PORT
if [[ ${FILE_cryptonote_config} == *const\ int\ *RPC_DEFAULT_PORT\ *\=\ *${RPC_DEFAULT_PORT}* ]]
then
	echo "TEST PASSED - RPC_DEFAULT_PORT change"
else
	echo "TEST FAILED - RPC_DEFAULT_PORT change"
	TESTS_PASSED=0
fi

# Test MAX_BLOCK_SIZE_INITIAL
if [[ ${FILE_cryptonote_config} == *const\ size_t\ *MAX_BLOCK_SIZE_INITIAL\ *\=\ *${MAX_BLOCK_SIZE_INITIAL}* ]]
then
	echo "TEST PASSED - MAX_BLOCK_SIZE_INITIAL change"
else
	echo "TEST FAILED - MAX_BLOCK_SIZE_INITIAL change"
	TESTS_PASSED=0
fi

# Test CRYPTONOTE_NAME
if [[ ${FILE_cryptonote_config} == *const\ char\ *CRYPTONOTE_NAME\[\]\ *=\ *\"${CRYPTONOTE_NAME}\"* ]]
then
	echo "TEST PASSED - CRYPTONOTE_NAME change"
else
	echo "TEST FAILED - CRYPTONOTE_NAME change"
	TESTS_PASSED=0
fi

# Test UPGRADE_HEIGHT
if [[ ${FILE_cryptonote_config} == *const\ uint64_t\ *UPGRADE_HEIGHT\ *=\ *${UPGRADE_HEIGHT}* ]]
then
	echo "TEST PASSED - UPGRADE_HEIGHT change"
else
	echo "TEST FAILED - UPGRADE_HEIGHT change"
	TESTS_PASSED=0
fi

# Test P2P_STAT_TRUSTED_PUB_KEY
if [[ ${FILE_cryptonote_config} == *const\ char\ *P2P_STAT_TRUSTED_PUB_KEY\[\]\ *\=\ *\"${P2P_STAT_TRUSTED_PUB_KEY}\"* ]]
then
	echo "TEST PASSED - P2P_STAT_TRUSTED_PUB_KEY change"
else
	echo "TEST FAILED - P2P_STAT_TRUSTED_PUB_KEY change"
	TESTS_PASSED=0
fi

# Test SEED_NODES
IFS=', ' read -a array <<< "${SEED_NODES}"
for element in "${array[@]}"
do
	if [[ ${FILE_cryptonote_config} != *const\ char\ *const\ *SEED_NODES\[\]\ *\=\ *{*${element}* ]]; then
		echo "TEST FAILED - SEED_NODES change"
		TESTS_PASSED=0
	fi
done

if [[ TESTS_PASSED == 1 ]]; then
	echo "TEST PASSED - SEED_NODES change"
fi

# Test CHECKPOINTS
IFS='}, ' read -a array <<< "${CHECKPOINTS}"
for element in "${array[@]}"
do
	if [[ ${FILE_cryptonote_config} != *const\ CheckpointData\ *CHECKPOINTS\[\]*\=\ *${element}* ]]; then
		echo "TEST FAILED - CHECKPOINTS change"
		TESTS_PASSED=0
	fi
done
if [[ TESTS_PASSED == 1 ]]; then
	echo "TEST PASSED - CHECKPOINTS change"
fi
FILE_cryptonote_config=""

FILE_Currency=$(<${TEMP_PATH}"/src/cryptonote_core/Currency.cpp")
# Test genesisCoinbaseTxHex
if [[ ${FILE_Currency} == *std::string\ genesisCoinbaseTxHex\ *\=\ *\"${genesisCoinbaseTxHex}\"* ]]
then
	echo "TEST PASSED - genesisCoinbaseTxHex change"
else
	echo "TEST FAILED - genesisCoinbaseTxHex change"
	TESTS_PASSED=0
fi
FILE_Currency=""


FILE_p2p_networks=$(<${TEMP_PATH}"/src/p2p/p2p_networks.h")
# Test BYTECOIN_NETWORK
if [[ ${FILE_p2p_networks} == *const\ static\ boost::uuids::uuid\ BYTECOIN_NETWORK\ *\=\ *{\ {\ ${BYTECOIN_NETWORK}\ }\ }* ]]
then
	echo "TEST PASSED - BYTECOIN_NETWORK change"
else
	echo "TEST FAILED - BYTECOIN_NETWORK change"
	TESTS_PASSED=0
fi
FILE_p2p_networks=""

# Custom tests
if [ -f "${CUSTOM_CUSTOMIZE_TESTS_PATH}"  ]; then
	. "${CUSTOM_CUSTOMIZE_TESTS_PATH}"
fi
