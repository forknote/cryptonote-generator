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


# src/cryptonote_core/cryptonote_core.cpp
FILE_cryptonote_core_cpp=$(<${TEMP_PATH}"/src/cryptonote_core/cryptonote_core.cpp")

# Test amount_in_less_than_amount_out
if [[ ${FILE_cryptonote_core_cpp} == *if\ \(amount_in\ \<\ amount_out\)\ \{* ]]
then
	echo "TEST PASSED - cryptonote_core.cpp - amount_in_less_than_amount_out change (allow-0-fee-tx)"
else
	echo "TEST FAILED - cryptonote_core.cpp - amount_in_less_than_amount_out change (allow-0-fee-tx)"
	exit 2
fi

FILE_cryptonote_core_cpp=''


# src/cryptonote_core/tx_pool.cpp
FILE_tx_pool_cpp=$(<${TEMP_PATH}"/src/cryptonote_core/tx_pool.cpp")

# Test tx_pool_output_more_input
if [[ ${FILE_tx_pool_cpp} == *if\ \(outputs_amount\ \>\ inputs_amount\)\ \{* ]]
then
	echo "TEST PASSED - tx_pool.cpp - tx_pool_output_more_input change (allow-0-fee-tx)"
else
	echo "TEST FAILED - tx_pool.cpp - tx_pool_output_more_input change (allow-0-fee-tx)"
	exit 2
fi

# Test tx_pool_inputsValid
if [[ ${FILE_tx_pool_cpp} == *if\ \(inputsValid\)* ]]
then
	echo "TEST PASSED - tx_pool.cpp - tx_pool_inputsValid change (allow-0-fee-tx)"
else
	echo "TEST FAILED - tx_pool.cpp - tx_pool_inputsValid change (allow-0-fee-tx)"
	exit 2
fi

FILE_tx_pool_cpp=''