#! /usr/bin/env bash


# Bash script for change coin files

# Exit immediately if an error occurs, or if an undeclared variable is used
set -o errexit

[ "$OSTYPE" != "win"* ] || die "Install Cygwin to use on Windows"

# Set directory vars
. "vars.cfg"

# src/CMakeLists.txt
FILE_CMakeLists=$(<${TEMP_PATH}"/src/CMakeLists.txt")

# Test daemon name change
if [[ ${FILE_CMakeLists} == *set_property\(TARGET\ daemon\ PROPERTY\ OUTPUT_NAME*${__tick_data_core_daemon_name}* ]]
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
if [[ ${FILE_cryptonote_config} == *const\ char\ *CRYPTONOTE_NAME\[\]\ *=\ *\"${__tick_data_core_CRYPTONOTE_NAME}\"* ]]
then
	echo "TEST PASSED - CRYPTONOTE_NAME change"
else
	echo "TEST FAILED - CRYPTONOTE_NAME change"
	exit 2
fi

# Test CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX
if [[ ${FILE_cryptonote_config} == *const\ uint64_t\ *CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX*\=*${__tick_data_core_CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX}* ]]
then
	echo "TEST PASSED - CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX change"
else
	echo "TEST FAILED - CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX change"
	exit 2
fi

# Test P2P_DEFAULT_PORT
if [[ ${FILE_cryptonote_config} == *const\ int\ *P2P_DEFAULT_PORT\ *\=\ *${__tick_data_core_P2P_DEFAULT_PORT}* ]]
then
	echo "TEST PASSED - P2P_DEFAULT_PORT change"
else
	echo "TEST FAILED - P2P_DEFAULT_PORT change"
	exit 2
fi

# Test RPC_DEFAULT_PORT
if [[ ${FILE_cryptonote_config} == *const\ int\ *RPC_DEFAULT_PORT\ *\=\ *${__tick_data_core_RPC_DEFAULT_PORT}* ]]
then
	echo "TEST PASSED - RPC_DEFAULT_PORT change"
else
	echo "TEST FAILED - RPC_DEFAULT_PORT change"
	exit 2
fi

# Test P2P_STAT_TRUSTED_PUB_KEY
if [[ ${FILE_cryptonote_config} == *const\ char\ *P2P_STAT_TRUSTED_PUB_KEY\[\]\ *\=\ *\"${__tick_data_core_P2P_STAT_TRUSTED_PUB_KEY}\"* ]]
then
	echo "TEST PASSED - P2P_STAT_TRUSTED_PUB_KEY change"
else
	echo "TEST FAILED - P2P_STAT_TRUSTED_PUB_KEY change"
	exit 2
fi

# Test SEED_NODES
if [[ ${FILE_cryptonote_config} == *const\ char\*\ *const\ *SEED_NODES\[\]\ *\=\ *{\ *${__tick_data_core_SEED_NODES}\ *}\;* ]]
then
	echo "TEST PASSED - SEED_NODES change"
else
	echo "TEST FAILED - SEED_NODES change"
	exit 2
fi

# Test CHECKPOINTS
if [[ ${FILE_cryptonote_config} == *${__tick_data_core_CHECKPOINTS}* ]]
then
	echo "TEST PASSED - CHECKPOINTS change"
else
	echo "TEST FAILED - CHECKPOINTS change"
	exit 2
fi


# Test UPGRADE_HEIGHT
__tick_data_core_UPGRADE_HEIGHT=${__tick_data_core_UPGRADE_HEIGHT:-1}
if [[ ${FILE_cryptonote_config} == *const\ uint64_t\ *UPGRADE_HEIGHT\ *=\ *${__tick_data_core_UPGRADE_HEIGHT}* ]]
then
	echo "TEST PASSED - UPGRADE_HEIGHT change"
else
	echo "TEST FAILED - UPGRADE_HEIGHT change"
	exit 2
fi

# MONEY_SUPPLY
if [ -n "$__tick_data_core_MONEY_SUPPLY" ]; then
if [[ ${FILE_cryptonote_config} == *const\ uint64_t\ *MONEY_SUPPLY\ *=\ *${__tick_data_core_MONEY_SUPPLY}\;* ]]; then
	echo "TEST PASSED - MONEY_SUPPLY change"
else
	echo "TEST FAILED - MONEY_SUPPLY change"
	exit 2
fi
fi

# EMISSION_SPEED_FACTOR
if [ -n "$__tick_data_core_EMISSION_SPEED_FACTOR" ]; then
if [[ ${FILE_cryptonote_config} == *const\ unsigned\ *EMISSION_SPEED_FACTOR\ *=\ *${__tick_data_core_EMISSION_SPEED_FACTOR}* ]]; then
	echo "TEST PASSED - EMISSION_SPEED_FACTOR change"
else
	echo "TEST FAILED - EMISSION_SPEED_FACTOR change"
	exit 2
fi
fi

# DIFFICULTY_TARGET
if [ -n "$__tick_data_core_DIFFICULTY_TARGET" ]; then
if [[ ${FILE_cryptonote_config} == *const\ uint64_t\ *DIFFICULTY_TARGET\ *=\ *${__tick_data_core_DIFFICULTY_TARGET}* ]]; then
	echo "TEST PASSED - DIFFICULTY_TARGET change"
else
	echo "TEST FAILED - DIFFICULTY_TARGET change"
	exit 2
fi
fi

# COIN
if [ -n "$__tick_data_core_COIN" ]; then
if [[ ${FILE_cryptonote_config} == *const\ uint64_t\ *COIN\ *=\ *UINT64_C\(\ ${__tick_data_core_COIN}\)* ]]; then
	echo "TEST PASSED - COIN change"
else
	echo "TEST FAILED - COIN change"
	exit 2
fi
fi

# CRYPTONOTE_DISPLAY_DECIMAL_POINT
if [ -n "$__tick_data_core_CRYPTONOTE_DISPLAY_DECIMAL_POINT" ]; then
if [[ ${FILE_cryptonote_config} == *const\ size_t\ *CRYPTONOTE_DISPLAY_DECIMAL_POINT\ *=\ *${__tick_data_core_CRYPTONOTE_DISPLAY_DECIMAL_POINT}* ]]; then
	echo "TEST PASSED - CRYPTONOTE_DISPLAY_DECIMAL_POINT change"
else
	echo "TEST FAILED - CRYPTONOTE_DISPLAY_DECIMAL_POINT change"
	exit 2
fi
fi

# MINIMUM_FEE
if [ -n "$__tick_data_core_MINIMUM_FEE" ]; then 
if [[ ${FILE_cryptonote_config} == *const\ uint64_t\ *MINIMUM_FEE\ *=\ *UINT64_C\(\ ${__tick_data_core_MINIMUM_FEE}\)* ]]; then
	echo "TEST PASSED - MINIMUM_FEE change"
else
	echo "TEST FAILED - MINIMUM_FEE change"
	exit 2
fi
fi

# DEFAULT_DUST_THRESHOLD
if [ -n "$__tick_data_core_DEFAULT_DUST_THRESHOLD" ]; then
if [[ ${FILE_cryptonote_config} == *const\ uint64_t\ *DEFAULT_DUST_THRESHOLD\ *=\ *UINT64_C\(\ ${__tick_data_core_DEFAULT_DUST_THRESHOLD}\)* ]]; then
	echo "TEST PASSED - DEFAULT_DUST_THRESHOLD change"
else
	echo "TEST FAILED - DEFAULT_DUST_THRESHOLD change"
	exit 2
fi
fi

# Test CRYPTONOTE_MINED_MONEY_UNLOCK_WINDOW
if [ -n "$__tick_data_core_CRYPTONOTE_MINED_MONEY_UNLOCK_WINDOW" ]; then
if [[ ${FILE_cryptonote_config} == *const\ size_t\ *CRYPTONOTE_MINED_MONEY_UNLOCK_WINDOW\ *\=\ *${__tick_data_core_CRYPTONOTE_MINED_MONEY_UNLOCK_WINDOW}* ]]
then
	echo "TEST PASSED - CRYPTONOTE_MINED_MONEY_UNLOCK_WINDOW change"
else
	echo "TEST FAILED - CRYPTONOTE_MINED_MONEY_UNLOCK_WINDOW change"
	exit 2
fi
fi

# Test CRYPTONOTE_BLOCK_GRANTED_FULL_REWARD_ZONE
if [ -n "$__tick_data_core_CRYPTONOTE_BLOCK_GRANTED_FULL_REWARD_ZONE" ]; then
if [[ ${FILE_cryptonote_config} == *const\ size_t\ *CRYPTONOTE_BLOCK_GRANTED_FULL_REWARD_ZONE\ *\=\ *${__tick_data_core_CRYPTONOTE_BLOCK_GRANTED_FULL_REWARD_ZONE}* ]]
then
	echo "TEST PASSED - CRYPTONOTE_BLOCK_GRANTED_FULL_REWARD_ZONE change"
else
	echo "TEST FAILED - CRYPTONOTE_BLOCK_GRANTED_FULL_REWARD_ZONE change"
	exit 2
fi
fi

# Test CRYPTONOTE_BLOCK_GRANTED_FULL_REWARD_ZONE_V1
if [ -n "$__tick_data_core_CRYPTONOTE_BLOCK_GRANTED_FULL_REWARD_ZONE_V1" ]; then
if [[ ${FILE_cryptonote_config} == *const\ size_t\ *CRYPTONOTE_BLOCK_GRANTED_FULL_REWARD_ZONE_V1\ *\=\ *${__tick_data_core_CRYPTONOTE_BLOCK_GRANTED_FULL_REWARD_ZONE_V1}* ]]
then
	echo "TEST PASSED - CRYPTONOTE_BLOCK_GRANTED_FULL_REWARD_ZONE_V1 change"
else
	echo "TEST FAILED - CRYPTONOTE_BLOCK_GRANTED_FULL_REWARD_ZONE_V1 change"
	exit 2
fi
fi

# The following test does not work with the json parser.
# * is not parsed correctly

# Test MAX_BLOCK_SIZE_INITIAL
#if [ -n "$__tick_data_core_MAX_BLOCK_SIZE_INITIAL" ]; then
#if [[ ${FILE_cryptonote_config} == *const\ size_t\ *MAX_BLOCK_SIZE_INITIAL\ *\=\ *\"${__tick_data_core_MAX_BLOCK_SIZE_INITIAL}\"* ]]
#then
#	echo "TEST PASSED - MAX_BLOCK_SIZE_INITIAL change"
#else
#	echo "TEST FAILED - MAX_BLOCK_SIZE_INITIAL change"
#	exit 2
#fi
#fi

FILE_cryptonote_config=""


# src/cryptonote_core/Currency.cpp
FILE_Currency=$(<${TEMP_PATH}"/src/cryptonote_core/Currency.cpp")

# Test genesisCoinbaseTxHex
if [[ ${FILE_Currency} == *std::string\ genesisCoinbaseTxHex\ *\=\ *\"${__tick_data_core_genesisCoinbaseTxHex}\"* ]]
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
if [[ ${FILE_p2p_networks} == *const\ static\ boost::uuids::uuid\ BYTECOIN_NETWORK\ *\=\ *{\ {\ ${__tick_data_core_BYTECOIN_NETWORK}}\ }* ]]
then
	echo "TEST PASSED - BYTECOIN_NETWORK change"
else
	echo "TEST FAILED - BYTECOIN_NETWORK change"
	exit 2
fi

FILE_p2p_networks=""

