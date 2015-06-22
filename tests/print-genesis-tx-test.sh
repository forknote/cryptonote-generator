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


# src/daemon/daemon.cpp
FILE_daemon_cpp=$(<${TEMP_PATH}"/src/daemon/daemon.cpp")

# Test daemon_text_1
if [[ ${FILE_daemon_cpp} == *arg_print_genesis_tx\ \=\ \{\ \"print-genesis-tx\"* ]]
then
	echo "TEST PASSED - daemon.cpp - daemon_text_1 change (print-genesis-tx)"
else
	echo "TEST FAILED - daemon.cpp - daemon_text_1 change (print-genesis-tx)"
	exit 2
fi

# Test daemon_text_2
if [[ ${FILE_daemon_cpp} == *command_line\:\:add_arg\(desc_cmd_sett\,\ arg_print_genesis_tx\)\;* ]]
then
	echo "TEST PASSED - daemon.cpp - daemon_text_2 change (print-genesis-tx)"
else
	echo "TEST FAILED - daemon.cpp - daemon_text_2 change (print-genesis-tx)"
	exit 2
fi

# Test daemon_text_3
if [[ ${FILE_daemon_cpp} == *if\ \(command_line\:\:get_arg\(vm\,\ arg_print_genesis_tx\)\)\ \{* ]]
then
	echo "TEST PASSED - daemon.cpp - daemon_text_3 change (print-genesis-tx)"
else
	echo "TEST FAILED - daemon.cpp - daemon_text_3 change (print-genesis-tx)"
	exit 2
fi

# Test daemon_text_4
if [[ ${FILE_daemon_cpp} == *\"GENESIS_COINBASE_TX_HEX\ constant\ has\ an\ incorrect\ value\.* ]]
then
	echo "TEST PASSED - daemon.cpp - daemon_text_4 change (print-genesis-tx)"
else
	echo "TEST FAILED - daemon.cpp - daemon_text_4 change (print-genesis-tx)"
	exit 2
fi

if [[ " ${__CONFIG_plugins_text} " != *"multiply.py"* ]]; then
	# Test daemon_text_5
	if [[ ${FILE_daemon_cpp} == *void\ print_genesis_tx_hex\(const\ po\:\:variables_map\&\ vm\,\ LoggerManager\&\ logManager\)\ \{* ]]
	then
		echo "TEST PASSED - daemon.cpp - daemon_text_5 change (print-genesis-tx)"
	else
		echo "TEST FAILED - daemon.cpp - daemon_text_5 change (print-genesis-tx)"
		exit 2
	fi
fi

FILE_daemon_cpp=""


# src/cryptonote_core/Currency.cpp
FILE_Currency_cpp=$(<${TEMP_PATH}"/src/cryptonote_core/Currency.cpp")

# Test currency_cpp_text_1
if [[ ${FILE_Currency_cpp} == *Transaction\ CurrencyBuilder\:\:generateGenesisTransaction\(\)\ \{* ]]
then
	echo "TEST PASSED - Currency.cpp - currency_cpp_text_1 change (print-genesis-tx)"
else
	echo "TEST FAILED - Currency.cpp - currency_cpp_text_1 change (print-genesis-tx)"
	exit 2
fi

FILE_Currency_cpp=""


# src/cryptonote_core/Currency.h
FILE_Currency_h=$(<${TEMP_PATH}"/src/cryptonote_core/Currency.h")

# Test currency_h_text_1
if [[ ${FILE_Currency_h} == *Transaction\ generateGenesisTransaction\(\)\;* ]]
then
	echo "TEST PASSED - Currency.h - currency_h_text_1 change (print-genesis-tx)"
else
	echo "TEST FAILED - Currency.h - currency_h_text_1 change (print-genesis-tx)"
	exit 2
fi

FILE_Currency_h=""
