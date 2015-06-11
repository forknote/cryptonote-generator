#! /usr/bin/env bash


# Bash script for change coin files

# Exit immediately if an error occurs, or if an undeclared variable is used
set -o errexit

[ "$OSTYPE" != "win"* ] || die "Install Cygwin to use on Windows"

while getopts "d:" opt; do
    case "$opt" in
    d)  TEMP_PATH=${OPTARG}
        ;;
    esac
done

shift $((OPTIND-1))

if [ ! -d ${TEMP_PATH} ]; then
	echo "ERROR: Target directory does not exits"	
	exit
fi

# src/cryptonote_config.h
FILE_cryptonote_config=$(<${TEMP_PATH}"/src/cryptonote_config.h")

# Test GENESIS_COINBASE_TX_HEX
if [[ ${FILE_cryptonote_config} == *const\ char\ *GENESIS_COINBASE_TX_HEX\[\]* ]]
then
	echo "TEST PASSED - cryptonote_config.h - GENESIS_COINBASE_TX_HEX change (multiply)"
else
	echo "TEST FAILED - cryptonote_config.h - GENESIS_COINBASE_TX_HEX change (multiply)"
	exit 2
fi

FILE_cryptonote_config=""


# src/daemon/daemon.cpp
FILE_daemon_cpp=$(<${TEMP_PATH}"/src/daemon/daemon.cpp")

# Test arg_config_file
if [[ ${FILE_daemon_cpp} == *arg_config_file\ *\"\.\/configs\/\-\.conf\"* ]]
then
	echo "TEST PASSED - daemon.cpp - arg_config_file change (multiply)"
else
	echo "TEST FAILED - daemon.cpp - arg_config_file change (multiply)"
	exit 2
fi

# Test checkpoint_input
if [[ ${FILE_daemon_cpp} == *for\ \(const\ auto\&\ cp\ \:\ checkpoint_input\)* ]]
then
	echo "TEST PASSED - daemon.cpp - checkpoint_input change (multiply)"
else
	echo "TEST FAILED - daemon.cpp - checkpoint_input change (multiply)"
	exit 2
fi

# Test common_command_line_descriptors
if [[ ${FILE_daemon_cpp} == *arg_UPGRADE_HEIGHT\ \ \=\ \{\"UPGRADE_HEIGHT\"\,\ \"uint64_t\"\,\ 0\}* ]]
then
	echo "TEST PASSED - daemon.cpp - common_command_line_descriptors change (multiply)"
else
	echo "TEST FAILED - daemon.cpp - common_command_line_descriptors change (multiply)"
	exit 2
fi

# Test daemon_command_line_descriptors
if [[ ${FILE_daemon_cpp} == *arg_CRYPTONOTE_NAME\ \ \=\ \{\"CRYPTONOTE_NAME\"* ]]
then
	echo "TEST PASSED - daemon.cpp - daemon_command_line_descriptors change (multiply)"
else
	echo "TEST FAILED - daemon.cpp - daemon_command_line_descriptors change (multiply)"
	exit 2
fi

# Test daemon_cryptonote_name_includes
if [[ ${FILE_daemon_cpp} == *\#include\ \<boost\/algorithm\/string\.hpp\>* ]]
then
	echo "TEST PASSED - daemon.cpp - daemon_cryptonote_name_includes change (multiply)"
else
	echo "TEST FAILED - daemon.cpp - daemon_cryptonote_name_includes change (multiply)"
	exit 2
fi

# Test daemon_undeclared_options_config
if [[ ${FILE_daemon_cpp} == *po\:\:store\(po\:\:parse_config_file\<char\>\(config_path\.string\<std\:\:string\>\(\)\.c_str\(\)\,\ desc_cmd_sett\,\ true\)\,\ vm\)\;* ]]
then
	echo "TEST PASSED - daemon.cpp - daemon_undeclared_options_config change (multiply)"
else
	echo "TEST FAILED - daemon.cpp - daemon_undeclared_options_config change (multiply)"
	exit 2
fi

# Test daemon_print_genesis_tx
if [[ ${FILE_daemon_cpp} == *CryptoNote\:\:Transaction\ tx\ \=\ currencyBuilder\.generateGenesisTransaction\(\)\;* ]]
then
	echo "TEST PASSED - daemon.cpp - daemon_print_genesis_tx change (multiply)"
else
	echo "TEST FAILED - daemon.cpp - daemon_print_genesis_tx change (multiply)"
	exit 2
fi

# Test void_print_genesis_tx_hex
if [[ ${FILE_daemon_cpp} == *void\ print_genesis_tx_hex\(LoggerManager\&\ logManager\,\ const\ * ]]
then
	echo "TEST PASSED - daemon.cpp - void_print_genesis_tx_hex change (multiply)"
else
	echo "TEST FAILED - daemon.cpp - void_print_genesis_tx_hex change (multiply)"
	exit 2
fi

# Test print_genesis_tx_hex
if [[ ${FILE_daemon_cpp} == *print_genesis_tx_hex\(logManager\,\ vm\)\;* ]]
then
	echo "TEST PASSED - daemon.cpp - print_genesis_tx_hex change (multiply)"
else
	echo "TEST FAILED - daemon.cpp - print_genesis_tx_hex change (multiply)"
	exit 2
fi

# Test print_genesis_tx_config_text
if [[ ${FILE_daemon_cpp} == *std\:\:cout\ \<\<\ \"GENESIS_COINBASE_TX_HEX\=\"\ \<\<\ tx_hex\ \<\<\ std\:\:endl\;* ]]
then
	echo "TEST PASSED - daemon.cpp - print_genesis_tx_config_text change (multiply)"
else
	echo "TEST FAILED - daemon.cpp - print_genesis_tx_config_text change (multiply)"
	exit 2
fi

# Test common_command_line_args
if [[ ${FILE_daemon_cpp} == *command_line\:\:add_arg\(desc_cmd_sett\,\ arg_UPGRADE_HEIGHT\)\;* ]]
then
	echo "TEST PASSED - daemon.cpp - common_command_line_args change (multiply)"
else
	echo "TEST FAILED - daemon.cpp - common_command_line_args change (multiply)"
	exit 2
fi

# Test daemon_command_line_args
if [[ ${FILE_daemon_cpp} == *add_arg\(desc_cmd_sett\,\ arg_CRYPTONOTE_NAME\)\;* ]]
then
	echo "TEST PASSED - daemon.cpp - daemon_command_line_args change (multiply)"
else
	echo "TEST FAILED - daemon.cpp - daemon_command_line_args change (multiply)"
	exit 2
fi

# Test currencyBuilder
if [[ ${FILE_daemon_cpp} == *currencyBuilder\.upgradeHeight\(command_line\:\:get_arg\(vm\,\ arg_UPGRADE_HEIGHT\)\)\;* ]]
then
	echo "TEST PASSED - daemon.cpp - currencyBuilder change (multiply)"
else
	echo "TEST FAILED - daemon.cpp - currencyBuilder change (multiply)"
	exit 2
fi

# Test checkpoints
if [[ ${FILE_daemon_cpp} == *if\ \(command_line\:\:has_arg\(vm\,\ arg_CHECKPOINT\)\ \&\&\ checkpoint_args\.size\(\)\ \!\=\ 0\)* ]]
then
	echo "TEST PASSED - daemon.cpp - checkpoints change (multiply)"
else
	echo "TEST FAILED - daemon.cpp - checkpoints change (multiply)"
	exit 2
fi

# Test minerConfig
if [[ ${FILE_daemon_cpp} == *if\ \(command_line\:\:has_arg\(vm\,\ arg_CRYPTONOTE_NAME\)\ \&\&* ]]
then
	echo "TEST PASSED - daemon.cpp - minerConfig change (multiply)"
else
	echo "TEST FAILED - daemon.cpp - minerConfig change (multiply)"
	exit 2
fi

FILE_daemon_cpp=""

# src/cryptonote_core/Currency.h
FILE_Currency_h=$(<${TEMP_PATH}"/src/cryptonote_core/Currency.h")

# Test currency_vars
if [[ ${FILE_Currency_h} == *std\:\:string\ m_genesisCoinbaseTxHex\;* ]]
then
	echo "TEST PASSED - Currency.h - currency_vars change (multiply)"
else
	echo "TEST FAILED - Currency.h - currency_vars change (multiply)"
	exit 2
fi

# Test currency_builder_params
if [[ ${FILE_Currency_h} == *CurrencyBuilder\&\ genesisCoinbaseTxHex\(const* ]]
then
	echo "TEST PASSED - Currency.h - currency_builder_params change (multiply)"
else
	echo "TEST FAILED - Currency.h - currency_builder_params change (multiply)"
	exit 2
fi

FILE_Currency_h=""


# src/cryptonote_core/Currency.cpp
FILE_Currency_cpp=$(<${TEMP_PATH}"/src/cryptonote_core/Currency.cpp")

# Test GENESIS_COINBASE_TX_HEX_var_name
if [[ ${FILE_Currency_cpp} == *genesisCoinbaseTxHex\ \=*m_genesisCoinbaseTxHex* ]]
then
	echo "TEST PASSED - Currency.cpp - GENESIS_COINBASE_TX_HEX_var_name change (multiply)"
else
	echo "TEST FAILED - Currency.cpp - GENESIS_COINBASE_TX_HEX_var_name change (multiply)"
	exit 2
fi

FILE_Currency_cpp=""


# src/simplewallet/simplewallet.cpp
FILE_simplewallet_cpp=$(<${TEMP_PATH}"/src/simplewallet/simplewallet.cpp")

# Test arg_rpc_bind_port
if [[ ${FILE_simplewallet_cpp} == *std\:\:stoi\(command_line\:\:get_arg\(vm\,\ arg_rpc_bind_port\)\)* ]]
then
	echo "TEST PASSED - simplewallet.cpp - arg_rpc_bind_port change (multiply)"
else
	echo "TEST FAILED - simplewallet.cpp - arg_rpc_bind_port change (multiply)"
	exit 2
fi


# Test arg_rpc_bind_port
if [[ ${FILE_simplewallet_cpp} == *std\:\:stoi\(command_line\:\:get_arg\(vm\,\ arg_rpc_bind_port\)\)* ]]
then
	echo "TEST PASSED - simplewallet.cpp - arg_rpc_bind_port change (multiply)"
else
	echo "TEST FAILED - simplewallet.cpp - arg_rpc_bind_port change (multiply)"
	exit 2
fi


# Test simplewallet_command_line_descriptors
if [[ ${FILE_simplewallet_cpp} == *\<std\:\:string\>\ arg_config_file\ \=\ \{\"config-file\"\,* ]]
then
	echo "TEST PASSED - simplewallet.cpp - simplewallet_command_line_descriptors change (multiply)"
else
	echo "TEST FAILED - simplewallet.cpp - simplewallet_command_line_descriptors change (multiply)"
	exit 2
fi

# Test common_command_line_descriptors
if [[ ${FILE_simplewallet_cpp} == *arg_UPGRADE_HEIGHT\ \ \=\ \{\"UPGRADE_HEIGHT\"\,* ]]
then
	echo "TEST PASSED - simplewallet.cpp - common_command_line_descriptors change (multiply)"
else
	echo "TEST FAILED - simplewallet.cpp - common_command_line_descriptors change (multiply)"
	exit 2
fi

# Test simplewallet_daemon_port_descriptor
if [[ ${FILE_simplewallet_cpp} == *\<std\:\:string\>\ arg_rpc_bind_port\ \=\ \{\"rpc-bind-port\"\,* ]]
then
	echo "TEST PASSED - simplewallet.cpp - simplewallet_daemon_port_descriptor change (multiply)"
else
	echo "TEST FAILED - simplewallet.cpp - simplewallet_daemon_port_descriptor change (multiply)"
	exit 2
fi

# Test simplewallet_command_line_args
if [[ ${FILE_simplewallet_cpp} == *command_line\:\:add_arg\(desc_params\,\ arg_config_file\)\;* ]]
then
	echo "TEST PASSED - simplewallet.cpp - simplewallet_command_line_args change (multiply)"
else
	echo "TEST FAILED - simplewallet.cpp - simplewallet_command_line_args change (multiply)"
	exit 2
fi

# Test simplewallet_common_command_line_args
if [[ ${FILE_simplewallet_cpp} == *command_line\:\:add_arg\(desc_params\,\ arg_UPGRADE_HEIGHT\)\;* ]]
then
	echo "TEST PASSED - simplewallet.cpp - simplewallet_common_command_line_args change (multiply)"
else
	echo "TEST FAILED - simplewallet.cpp - simplewallet_common_command_line_args change (multiply)"
	exit 2
fi

# Test simplewallet_daemon_port_arg
if [[ ${FILE_simplewallet_cpp} == *command_line\:\:add_arg\(desc_params\,\ arg_rpc_bind_port\)\;* ]]
then
	echo "TEST PASSED - simplewallet.cpp - simplewallet_daemon_port_arg change (multiply)"
else
	echo "TEST FAILED - simplewallet.cpp - simplewallet_daemon_port_arg change (multiply)"
	exit 2
fi

# Test simplewallet_config_file_args
if [[ ${FILE_simplewallet_cpp} == *std\:\:string\ config\ \=\ command_line\:\:get_arg\(vm\,\ arg_config_file\)\;* ]]
then
	echo "TEST PASSED - simplewallet.cpp - simplewallet_config_file_args change (multiply)"
else
	echo "TEST FAILED - simplewallet.cpp - simplewallet_config_file_args change (multiply)"
	exit 2
fi

# Test currencyBuilder_params
if [[ ${FILE_simplewallet_cpp} == *currencyBuilder\.moneySupply\(command_line\:\:get_arg\(vm\,\ arg_MONEY_SUPPLY\)\)\;* ]]
then
	echo "TEST PASSED - simplewallet.cpp - currencyBuilder_params change (multiply)"
else
	echo "TEST FAILED - simplewallet.cpp - currencyBuilder_params change (multiply)"
	exit 2
fi

# Test currencyBuilder_testnet
if [[ ${FILE_simplewallet_cpp} == *currencyBuilder\.testnet\(command_line\:\:get_arg\(vm\,\ arg_testnet\)\)\;* ]]
then
	echo "TEST PASSED - simplewallet.cpp - currencyBuilder_testnet change (multiply)"
else
	echo "TEST FAILED - simplewallet.cpp - currencyBuilder_testnet change (multiply)"
	exit 2
fi

FILE_simplewallet_cpp=""


# src/wallet/wallet_rpc_server.cpp
FILE_wallet_rpc_server_cpp=$(<${TEMP_PATH}"/src/wallet/wallet_rpc_server.cpp")

# Test wallet_rpc_bind_port_var_name
if [[ ${FILE_wallet_rpc_server_cpp} == *wallet-rpc-bind-port* ]]
then
	echo "TEST PASSED - wallet_rpc_server.cpp - wallet_rpc_bind_port_var_name change (multiply)"
else
	echo "TEST FAILED - wallet_rpc_server.cpp - wallet_rpc_bind_port_var_name change (multiply)"
	exit 2
fi

# Test wallet_rpc_bind_ip_var_name
if [[ ${FILE_wallet_rpc_server_cpp} == *wallet-rpc-bind-ip* ]]
then
	echo "TEST PASSED - wallet_rpc_server.cpp - wallet_rpc_bind_ip_var_name change (multiply)"
else
	echo "TEST FAILED - wallet_rpc_server.cpp - wallet_rpc_bind_ip_var_name change (multiply)"
	exit 2
fi

FILE_wallet_rpc_server_cpp=""


# src/p2p/NetNodeConfig.h
FILE_NetNodeConfig_h=$(<${TEMP_PATH}"/src/p2p/NetNodeConfig.h")

# Test NetNodeConfig_h_includes
if [[ ${FILE_NetNodeConfig_h} == *\#include\ \"p2p_networks\.h\"* ]]
then
	echo "TEST PASSED - NetNodeConfig.h - NetNodeConfig_h_includes change (multiply)"
else
	echo "TEST FAILED - NetNodeConfig.h - NetNodeConfig_h_includes change (multiply)"
	exit 2
fi

# Test NetNodeConfig_h_vars
if [[ ${FILE_NetNodeConfig_h} == *boost\:\:uuids\:\:uuid\ networkId\;* ]]
then
	echo "TEST PASSED - NetNodeConfig.h - NetNodeConfig_h_vars change (multiply)"
else
	echo "TEST FAILED - NetNodeConfig.h - NetNodeConfig_h_vars change (multiply)"
	exit 2
fi

FILE_NetNodeConfig_h=""


# src/p2p/NetNodeConfig.cpp
FILE_NetNodeConfig_cpp=$(<${TEMP_PATH}"/src/p2p/NetNodeConfig.cpp")

# Test NetNodeConfig_cpp_command_line_descriptors
if [[ ${FILE_NetNodeConfig_cpp} == *\<std\:\:string\>\ arg_network_id\ \=\ \{\"BYTECOIN_NETWORK\"* ]]
then
	echo "TEST PASSED - NetNodeConfig.cpp - NetNodeConfig_cpp_command_line_descriptors change (multiply)"
else
	echo "TEST FAILED - NetNodeConfig.cpp - NetNodeConfig_cpp_command_line_descriptors change (multiply)"
	exit 2
fi

# Test NetNodeConfig_cpp_command_line_args
if [[ ${FILE_NetNodeConfig_cpp} == *command_line\:\:add_arg\(desc\,\ arg_network_id\)\;* ]]
then
	echo "TEST PASSED - NetNodeConfig.cpp - NetNodeConfig_cpp_command_line_args change (multiply)"
else
	echo "TEST FAILED - NetNodeConfig.cpp- NetNodeConfig_cpp_command_line_args change (multiply)"
	exit 2
fi

# Test NetNodeConfig_cpp_get_args
if [[ ${FILE_NetNodeConfig_cpp} == *p2pStatTrustedPubKey\ \=\ command_line\:\:get_arg\(vm\,\ arg_P2P_STAT_TRUSTED_PUB_KEY\)\;* ]]
then
	echo "TEST PASSED - NetNodeConfig.cpp - NetNodeConfig_cpp_get_args change (multiply)"
else
	echo "TEST FAILED - NetNodeConfig.cpp- NetNodeConfig_cpp_get_args change (multiply)"
	exit 2
fi

# Test NetNodeConfig_cpp_vars
if [[ ${FILE_NetNodeConfig_cpp} == *p2pStatTrustedPubKey\ \=\ \"\"* ]]
then
	echo "TEST PASSED - NetNodeConfig.cpp - NetNodeConfig_cpp_vars change (multiply)"
else
	echo "TEST FAILED - NetNodeConfig.cpp- NetNodeConfig_cpp_vars change (multiply)"
	exit 2
fi

FILE_NetNodeConfig_cpp=""


# src/p2p/net_node.h
FILE_net_node_h=$(<${TEMP_PATH}"/src/p2p/net_node.h")

# Test net_node_h_includes
if [[ ${FILE_net_node_h} == *std\:\:string\ m_p2pStatTrustedPubKey\;* ]]
then
	echo "TEST PASSED - net_node.h - net_node_h_vars change (multiply)"
else
	echo "TEST FAILED - net_node.h - net_node_h_vars change (multiply)"
	exit 2
fi

FILE_net_node_h=""


# src/p2p/net_node.cpp
FILE_net_node_cpp=$(<${TEMP_PATH}"/src/p2p/net_node.cpp")

# Test if_no_seed_nodes
if [[ ${FILE_net_node_cpp} == *if\ \(\!testnet\ \&\&\ config\.seedNodes\.size\(\)\ \=\=\ 0\)\ \{* ]]
then
	echo "TEST PASSED - net_node.cpp - if_no_seed_nodes change (multiply)"
else
	echo "TEST FAILED - net_node.cpp - if_no_seed_nodes change (multiply)"
	exit 2
fi

# Test m_p2pStatTrustedPubKey
if [[ ${FILE_net_node_cpp} == *Common\:\:podFromHex\(m_p2pStatTrustedPubKey\,\ pk\)\;* ]]
then
	echo "TEST PASSED - net_node.cpp - m_p2pStatTrustedPubKey change (multiply)"
else
	echo "TEST FAILED - net_node.cpp - m_p2pStatTrustedPubKey change (multiply)"
	exit 2
fi

# Test net_node_cpp_vars
if [[ ${FILE_net_node_cpp} == *m_p2pStatTrustedPubKey\ \=\ config\.p2pStatTrustedPubKey\;* ]]
then
	echo "TEST PASSED - net_node.cpp - net_node_cpp_vars change (multiply)"
else
	echo "TEST FAILED - net_node.cpp - net_node_cpp_vars change (multiply)"
	exit 2
fi

FILE_net_node_cpp=""


# src/payment_service/CoinBaseConfiguration.cpp
FILE_CoinBaseConfiguration_cpp=$(<${TEMP_PATH}"/src/payment_service/CoinBaseConfiguration.cpp")

# Check is it populated
if [[ ${FILE_CoinBaseConfiguration_cpp} == *Forknote* ]]
then
	echo "TEST PASSED - CoinBaseConfiguration.cpp - populated (multiply)"
else
	echo "TEST FAILED - CoinBaseConfiguration.cpp - populated (multiply)"
	exit 2
fi

FILE_CoinBaseConfiguration_cpp=''


# src/payment_service/CoinBaseConfiguration.h
FILE_CoinBaseConfiguration_h=$(<${TEMP_PATH}"/src/payment_service/CoinBaseConfiguration.h")

# Check is it populated
if [[ ${FILE_CoinBaseConfiguration_h} == *Forknote* ]]
then
	echo "TEST PASSED - CoinBaseConfiguration.h - populated (multiply)"
else
	echo "TEST FAILED - CoinBaseConfiguration.h - populated (multiply)"
	exit 2
fi

FILE_CoinBaseConfiguration_h=''


# src/payment_service/ConfigurationManager.h
FILE_payment_service_ConfigurationManager_h=$(<${TEMP_PATH}"/src/payment_service/ConfigurationManager.h")

# Test ConfigurationManager_h_includes
if [[ ${FILE_payment_service_ConfigurationManager_h} == *\#include\ \"CoinBaseConfiguration\.h\"* ]]
then
	echo "TEST PASSED - payment_service/ConfigurationManager.h - ConfigurationManager_h_includes change (multiply)"
else
	echo "TEST FAILED - payment_service/ConfigurationManager.h - ConfigurationManager_h_includes change (multiply)"
	exit 2
fi

# Test ConfigurationManager_h_vars
if [[ ${FILE_payment_service_ConfigurationManager_h} == *RpcNodeConfiguration\ remoteNodeConfig\;* ]]
then
	echo "TEST PASSED - payment_service/ConfigurationManager.h - ConfigurationManager_h_vars change (multiply)"
else
	echo "TEST FAILED - payment_service/ConfigurationManager.h - ConfigurationManager_h_vars change (multiply)"
	exit 2
fi

FILE_payment_service_ConfigurationManager_h=''


# src/payment_service/ConfigurationManager.cpp
FILE_payment_service_ConfigurationManager_cpp=$(<${TEMP_PATH}"/src/payment_service/ConfigurationManager.cpp")

# Test ConfigurationManager_cpp_initOptions
if [[ ${FILE_payment_service_ConfigurationManager_cpp} == *CoinBaseConfiguration\:\:initOptions\(coinBaseOptions\)\;* ]]
then
	echo "TEST PASSED - payment_service/ConfigurationManager.cpp - ConfigurationManager_cpp_initOptions change (multiply)"
else
	echo "TEST FAILED - payment_service/ConfigurationManager.cpp - ConfigurationManager_cpp_initOptions change (multiply)"
	exit 2
fi

# Test confOptionsDesc
if [[ ${FILE_payment_service_ConfigurationManager_cpp} == *coinBaseConfig\.init\(confOptions\)\;* ]]
then
	echo "TEST PASSED - payment_service/ConfigurationManager.cpp - confOptionsDesc change (multiply)"
else
	echo "TEST FAILED - payment_service/ConfigurationManager.cpp - confOptionsDesc change (multiply)"
	exit 2
fi

# Test cmdOptionsDesc
#if [[ ${FILE_payment_service_ConfigurationManager_cpp} == *coinBaseConfig\.init\(cmdOptions\)\;* ]]
#then
#	echo "TEST PASSED - payment_service/ConfigurationManager.cpp - cmdOptionsDesc change (multiply)"
#else
#	echo "TEST FAILED - payment_service/ConfigurationManager.cpp - cmdOptionsDesc change (multiply)"
#	exit 2
#fi


# Test cmdOptionsDesc.add
if [[ ${FILE_payment_service_ConfigurationManager_cpp} == *cmdOptionsDesc\.add\(cmdGeneralOptions\)\.add\(remoteNodeOptions\)\.add\(netNodeOptions\)\.add\(coinBaseOptions\)\;* ]]
then
	echo "TEST PASSED - payment_service/ConfigurationManager.cpp - cmdOptionsDesc.add change (multiply)"
else
	echo "TEST FAILED - payment_service/ConfigurationManager.cpp - cmdOptionsDesc.add change (multiply)"
	exit 2
fi

# Test confOptionsDesc.add
if [[ ${FILE_payment_service_ConfigurationManager_cpp} == *confOptionsDesc\.add\(confGeneralOptions\)\.add\(remoteNodeOptions\)\.add\(netNodeOptions\)\.add\(coinBaseOptions\)\;* ]]
then
	echo "TEST PASSED - payment_service/ConfigurationManager.cpp - confOptionsDesc.add change (multiply)"
else
	echo "TEST FAILED - payment_service/ConfigurationManager.cpp - confOptionsDesc.add change (multiply)"
	exit 2
fi

# Test undeclaredOptionsInConfig
if [[ ${FILE_payment_service_ConfigurationManager_cpp} == *po\:\:store\(po\:\:parse_config_file\(confStream\,\ confOptionsDesc\,\ true\)\,\ confOptions\)\;* ]]
then
	echo "TEST PASSED - payment_service/ConfigurationManager.cpp - undeclaredOptionsInConfig change (multiply)"
else
	echo "TEST FAILED - payment_service/ConfigurationManager.cpp - undeclaredOptionsInConfig change (multiply)"
	exit 2
fi

# Test configDefaultValue
if [[ ${FILE_payment_service_ConfigurationManager_cpp} == *\(\"config\,c\"\,\ po\:\:value\<std\:\:string\>\(\)\-\>default_value\(\"\.\/configs\/\-\.conf\"\)\,\ \"configuration\ file\"\)\;* ]]
then
	echo "TEST PASSED - payment_service/ConfigurationManager.cpp - configDefaultValue change (multiply)"
else
	echo "TEST FAILED - payment_service/ConfigurationManager.cpp - configDefaultValue change (multiply)"
	exit 2
fi

FILE_payment_service_ConfigurationManager_cpp=''


# src/payment_service/main.cpp
FILE_payment_service_main_cpp=$(<${TEMP_PATH}"/src/payment_service/main.cpp")

# Test payment_service_main_currency_params
if [[ ${FILE_payment_service_main_cpp} == *currencyBuilder\-\>genesisCoinbaseTxHex\(config\.coinBaseConfig\.GENESIS_COINBASE_TX_HEX\)\;* ]]
then
	echo "TEST PASSED - payment_service/main.cpp - payment_service_main_currency_params change (multiply)"
else
	echo "TEST FAILED - payment_service/main.cpp - payment_service_main_currency_params change (multiply)"
	exit 2
fi

FILE_payment_service_main_cpp=''


# README.md
FILE_README_md=$(<${TEMP_PATH}"/README.md")

# Check is it populated
if [[ ${FILE_README_md} == *Forknote* ]]
then
	echo "TEST PASSED - README.md - populated (multiply)"
else
	echo "TEST FAILED - README.md - populated (multiply)"
	exit 2
fi

FILE_README_md=''
