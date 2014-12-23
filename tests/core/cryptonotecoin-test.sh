#! /usr/bin/env bash


# Bash script for change coin files

# Exit immediately if an error occurs, or if an undeclared variable is used
set -o errexit

[ "$OSTYPE" != "win"* ] || die "Install Cygwin to use on Windows"


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
if [[ ${FILE_cryptonote_config} =~ define\ *CRYPTONOTE_NAME\ *\"${__tick_data_core_CRYPTONOTE_NAME}\" ]]
then
	echo "TEST PASSED - CRYPTONOTE_NAME change"
else
	echo "TEST FAILED - CRYPTONOTE_NAME change"
	exit 2
fi

# Test CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX
if [[ ${FILE_cryptonote_config} =~ define\ *CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX\ *${__tick_data_core_CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX}* ]]
then
	echo "TEST PASSED - CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX change"
else
	echo "TEST FAILED - CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX change"
	exit 2
fi

# Test P2P_DEFAULT_PORT
if [[ ${FILE_cryptonote_config} =~ define\ *P2P_DEFAULT_PORT\ *${__tick_data_core_P2P_DEFAULT_PORT}* ]]
then
	echo "TEST PASSED - P2P_DEFAULT_PORT change"
else
	echo "TEST FAILED - P2P_DEFAULT_PORT change"
	exit 2
fi

# Test RPC_DEFAULT_PORT
if [[ ${FILE_cryptonote_config} =~ define\ *RPC_DEFAULT_PORT\ *${__tick_data_core_RPC_DEFAULT_PORT}* ]]
then
	echo "TEST PASSED - RPC_DEFAULT_PORT change"
else
	echo "TEST FAILED - RPC_DEFAULT_PORT change"
	exit 2
fi

# Test P2P_STAT_TRUSTED_PUB_KEY
__tick_data_core_P2P_STAT_TRUSTED_PUB_KEY=${__tick_data_core_P2P_STAT_TRUSTED_PUB_KEY:-}
if [[ ${FILE_cryptonote_config} =~ define\ *P2P_STAT_TRUSTED_PUB_KEY\ *\"${__tick_data_core_P2P_STAT_TRUSTED_PUB_KEY}\"* ]]
then
	echo "TEST PASSED - P2P_STAT_TRUSTED_PUB_KEY change"
else
	echo "TEST FAILED - P2P_STAT_TRUSTED_PUB_KEY change"
	exit 2
fi

# Test genesisCoinbaseTxHex
__tick_data_core_genesisCoinbaseTxHex=${__tick_data_core_genesisCoinbaseTxHex:-}
if [[ ${FILE_cryptonote_config} =~ define\ *GENESIS_COINBASE_TX_HEX\ *\"${__tick_data_core_genesisCoinbaseTxHex}\"* ]]; then
	echo "TEST PASSED - EMISSION_SPEED_FACTOR change"
else
	echo "TEST FAILED - EMISSION_SPEED_FACTOR change"
	exit 2
fi

# MONEY_SUPPLY
if [ -n "$__tick_data_core_MONEY_SUPPLY" ]; then
if [[ ${FILE_cryptonote_config} =~ define\ *MONEY_SUPPLY\ *${__tick_data_core_MONEY_SUPPLY}* ]]; then
	echo "TEST PASSED - MONEY_SUPPLY change"
else
	echo "TEST FAILED - MONEY_SUPPLY change"
	exit 2
fi
fi

# EMISSION_SPEED_FACTOR
if [ -n "$__tick_data_core_EMISSION_SPEED_FACTOR" ]; then
if [[ ${FILE_cryptonote_config} =~ define\ *EMISSION_SPEED_FACTOR\ *\(${__tick_data_core_EMISSION_SPEED_FACTOR}\)* ]]; then
	echo "TEST PASSED - EMISSION_SPEED_FACTOR change"
else
	echo "TEST FAILED - EMISSION_SPEED_FACTOR change"
	exit 2
fi
fi

# DIFFICULTY_TARGET
if [ -n "$__tick_data_core_DIFFICULTY_TARGET" ]; then
if [[ ${FILE_cryptonote_config} =~ define\ *DIFFICULTY_TARGET\ *${__tick_data_core_DIFFICULTY_TARGET}* ]]; then
	echo "TEST PASSED - DIFFICULTY_TARGET change"
else
	echo "TEST FAILED - DIFFICULTY_TARGET change"
	exit 2
fi
fi

# COIN
if [ -n "$__tick_data_core_COIN" ]; then
if [[ ${FILE_cryptonote_config} =~ define\ *COIN\ *${__tick_data_core_COIN}* ]]; then
	echo "TEST PASSED - COIN change"
else
	echo "TEST FAILED - COIN change"
	exit 2
fi
fi

# CRYPTONOTE_DISPLAY_DECIMAL_POINT
if [ -n "$__tick_data_core_CRYPTONOTE_DISPLAY_DECIMAL_POINT" ]; then
if [[ ${FILE_cryptonote_config} =~ define\ *CRYPTONOTE_DISPLAY_DECIMAL_POINT\ *${__tick_data_core_CRYPTONOTE_DISPLAY_DECIMAL_POINT}* ]]; then
	echo "TEST PASSED - CRYPTONOTE_DISPLAY_DECIMAL_POINT change"
else
	echo "TEST FAILED - CRYPTONOTE_DISPLAY_DECIMAL_POINT change"
	exit 2
fi
fi

# MINIMUM_FEE
if [ -n "$__tick_data_core_MINIMUM_FEE" ]; then 
if [[ ${FILE_cryptonote_config} =~ define\ *DEFAULT_FEE\ *${__tick_data_core_MINIMUM_FEE}* ]]; then
	echo "TEST PASSED - DEFAULT_FEE change"
else
	echo "TEST FAILED - DEFAULT_FEE change"
	exit 2
fi
fi

# Test CRYPTONOTE_MINED_MONEY_UNLOCK_WINDOW
if [ -n "$__tick_data_core_CRYPTONOTE_MINED_MONEY_UNLOCK_WINDOW" ]; then
if [[ ${FILE_cryptonote_config} =~ define\ *CRYPTONOTE_MINED_MONEY_UNLOCK_WINDOW\ *${__tick_data_core_CRYPTONOTE_MINED_MONEY_UNLOCK_WINDOW}* ]]
then
	echo "TEST PASSED - CRYPTONOTE_MINED_MONEY_UNLOCK_WINDOW change"
else
	echo "TEST FAILED - CRYPTONOTE_MINED_MONEY_UNLOCK_WINDOW change"
	exit 2
fi
fi

# Test CRYPTONOTE_BLOCK_GRANTED_FULL_REWARD_ZONE
if [ -n "$__tick_data_core_CRYPTONOTE_BLOCK_GRANTED_FULL_REWARD_ZONE" ]; then
if [[ ${FILE_cryptonote_config} =~ define\ *CRYPTONOTE_BLOCK_GRANTED_FULL_REWARD_ZONE\ *${__tick_data_core_CRYPTONOTE_BLOCK_GRANTED_FULL_REWARD_ZONE}* ]]
then
	echo "TEST PASSED - CRYPTONOTE_BLOCK_GRANTED_FULL_REWARD_ZONE change"
else
	echo "TEST FAILED - CRYPTONOTE_BLOCK_GRANTED_FULL_REWARD_ZONE change"
	exit 2
fi
fi

FILE_cryptonote_config=""


# src/p2p/p2p_networks.h
FILE_p2p_networks=$(<${TEMP_PATH}"/src/p2p/p2p_networks.h")

# Test BYTECOIN_NETWORK
if [[ ${FILE_p2p_networks} == *const\ static\ boost::uuids::uuid\ CRYPTONOTE_NETWORK\ *\=\ *{\ {\ ${__tick_data_core_BYTECOIN_NETWORK}}\ }* ]]
then
	echo "TEST PASSED - CRYPTONOTE_NETWORK change"
else
	echo "TEST FAILED - CRYPTONOTE_NETWORK change"
	exit 2
fi

FILE_p2p_networks=""
