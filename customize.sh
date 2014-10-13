#! /usr/bin/env bash


# Bash script for change coin files

# Exit immediately if an error occurs, or if an undeclared variable is used
set -o errexit
set -o nounset

[ "$OSTYPE" != "win"* ] || die "Windows is not supported"


# Set directory vars
. "vars.cfg"

# Set config vars
. "config-loader.sh" $1

# Make changes in src/CMakeLists.txt
if [[ "$OSTYPE" == "darwin"* ]]; then
	sed -i '.original' "s/\(set_property(TARGET daemon PROPERTY OUTPUT_NAME\).*/\1 \"${daemon_name}\")/" ${TEMP_PATH}"/src/CMakeLists.txt"
else
	sed -i "s/\(set_property(TARGET daemon PROPERTY OUTPUT_NAME\).*/\1 \"${daemon_name}\")/" ${TEMP_PATH}"/src/CMakeLists.txt"
fi

# Make changes in src/cryptonote_config.h
perl -0777 -i -pe "s/(const uint64_t\s+CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX)\s+=\s+\d+/\$1       = ${CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX}/" ${TEMP_PATH}"/src/cryptonote_config.h"
perl -0777 -i -pe "s/(const int\s+P2P_DEFAULT_PORT)\s+=\s+\d+/\$1       = ${P2P_DEFAULT_PORT}/" ${TEMP_PATH}"/src/cryptonote_config.h"
perl -0777 -i -pe "s/(const int\s+RPC_DEFAULT_PORT)\s+=\s+\d+/\$1       = ${RPC_DEFAULT_PORT}/" ${TEMP_PATH}"/src/cryptonote_config.h"
perl -0777 -i -pe "s/(const size_t\s+MAX_BLOCK_SIZE_INITIAL)\s+=\s+\d+ \* \d+/\$1       = ${MAX_BLOCK_SIZE_INITIAL}/" ${TEMP_PATH}"/src/cryptonote_config.h"
perl -0777 -i -pe "s/(const char\s+CRYPTONOTE_NAME\[\])\s+=\s+\"\w+\"/\$1       = \"${CRYPTONOTE_NAME}\"/" ${TEMP_PATH}"/src/cryptonote_config.h"
perl -0777 -i -pe "s/(const char\* const\s+SEED_NODES\[\] = {\\n).*?(\\n};)/\$1  ${SEED_NODES}\$2/s" ${TEMP_PATH}"/src/cryptonote_config.h"
perl -0777 -i -pe "s/(const CheckpointData\s+CHECKPOINTS\[\] = {\\n).*?(\\n};)/\$1  ${CHECKPOINTS}\$2/s" ${TEMP_PATH}"/src/cryptonote_config.h"
perl -0777 -i -pe "s/(const uint64_t\s+UPGRADE_HEIGHT)\s+=\s+\d+/\$1       = ${UPGRADE_HEIGHT}/" ${TEMP_PATH}"/src/cryptonote_config.h"
perl -0777 -i -pe "s/(const char\s+P2P_STAT_TRUSTED_PUB_KEY\[\])\s+=\s+\"\w+\"/\$1       = \"${P2P_STAT_TRUSTED_PUB_KEY}\"/" ${TEMP_PATH}"/src/cryptonote_config.h"

# Make changes in src/cryptonote_core/Currency.cpp
if [[ "$OSTYPE" == "darwin"* ]]; then
	sed -i '.original' "s/\(std::string genesisCoinbaseTxHex =\).*/\1 \"${genesisCoinbaseTxHex}\";/" ${TEMP_PATH}"/src/cryptonote_core/Currency.cpp"
else
	sed -i "s/\(std::string genesisCoinbaseTxHex =\).*/\1 \"${genesisCoinbaseTxHex}\";/" ${TEMP_PATH}"/src/cryptonote_core/Currency.cpp"
fi

# Make changes in src/p2p/p2p_networks.h
if [[ "$OSTYPE" == "darwin"* ]]; then
	sed -i '.original' "s/\(const static boost::uuids::uuid BYTECOIN_NETWORK =\).*/\1 { { ${BYTECOIN_NETWORK} } };/" ${TEMP_PATH}"/src/p2p/p2p_networks.h"
else
	sed -i "s/\(const static boost::uuids::uuid BYTECOIN_NETWORK =\).*/\1 { { ${BYTECOIN_NETWORK} } };/" ${TEMP_PATH}"/src/p2p/p2p_networks.h"
fi

# Custom scripts
if [ -f "${CUSTOM_CUSTOMIZE_SCRIPT_PATH}"  ]; then
	. "${CUSTOM_CUSTOMIZE_SCRIPT_PATH}"
fi

echo "Done file changes"