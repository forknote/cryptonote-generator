#! /usr/bin/env bash


# Bash script for automatic generation and deployment

# Exit immediately if an error occurs, or if an undeclared variable is used
set -o errexit

[ "$OSTYPE" != "win"* ] || die "Install Cygwin to use on Windows"

# Set directory vars
. "vars.cfg"

# Load libs
. "lib/ticktick.sh"

# Perform cleanup on exit
function finish {
	# Remove temporary files if exist
	echo "Remove temporary files..."
	rm -f "${UPDATES_PATH}"
	rm -rf "${TEMP_PATH}"
	rm -rf "${TEMP_GENESIS_PATH}"
}
trap finish EXIT


# Generate genesis
function generate_genesis {
	# Set backup var for Mac OS X
	EXTENSION=""
	if [[ "$OSTYPE" == "darwin"* ]]; then
	     EXTENSION=".original"
	fi

	genesis_coin_git="https://github.com/cryptonotefoundation/cryptonote.git"
	genesis_coin_plugin="core/cryptonotecoin.py"
	genesis_coin_test="core/cryptonotecoin-test.sh"

	rm -rf "${TEMP_GENESIS_PATH}"
	echo "Clone genesis coin..."
	git clone ${genesis_coin_git} "${TEMP_GENESIS_PATH}"

	export NEW_COIN_PATH=${TEMP_GENESIS_PATH}

	echo "Modify genesis coin"
	python "${PLUGINS_PATH}/${genesis_coin_plugin}" --config=$CONFIG_FILE --source=${TEMP_GENESIS_PATH}

	echo "Test genesis coin"
	TEMP_PATH_OLD=${TEMP_PATH}
	export TEMP_PATH=${TEMP_GENESIS_PATH}
	bash "${TESTS_PATH}/${genesis_coin_test}"
	export TEMP_PATH=${TEMP_PATH_OLD}

	bash "${SCRIPTS_PATH}/compile.sh" -c $COMPILE_ARGS

	GENESIS_COINBASE_TX_HEX="$( ${NEW_COIN_PATH}/build/release/src/``core[daemon_name]`` --print-genesis-tx | grep "GENESIS_COINBASE_TX_HEX" | awk '{ print $3 }' )"
	GENESIS_COINBASE_TX_HEX=${GENESIS_COINBASE_TX_HEX:1:${#GENESIS_COINBASE_TX_HEX}-2}
	echo Genesis block : ${GENESIS_COINBASE_TX_HEX}
	export __tick_data_core_genesisCoinbaseTxHex="${GENESIS_COINBASE_TX_HEX}"
	sed -i ${EXTENSION} "s/\(\"genesisCoinbaseTxHex\"\:\).*/\1\"${GENESIS_COINBASE_TX_HEX}\",/" $CONFIG_FILE
}

# Generate source code and compile 
function generate_coin {
	# Define coin paths
	export BASE_COIN_PATH="${WORK_FOLDERS_PATH}/"``base_coin[name]``
	export NEW_COIN_PATH="${WORK_FOLDERS_PATH}/"``core[CRYPTONOTE_NAME]``
	if [ -d "${BASE_COIN_PATH}" ]; then
		echo "Updating "``base_coin[name]``"..."
		git pull
	else
		echo "Cloning "``base_coin[name]``"..."
		git clone ``base_coin[git]`` "${BASE_COIN_PATH}"
	fi

	echo "Make temporary "``base_coin[name]``" copy..."
	[ -d "${TEMP_PATH}" ] || mkdir -p "${TEMP_PATH}"
	cp -af "${BASE_COIN_PATH}/." "${TEMP_PATH}"

	# Plugins
	echo "Personalize base coin source..."
	PLUGINS_LEN=``plugins.length()``
	COUNTER=0
	while [  $COUNTER -lt $PLUGINS_LEN ]; do
		plugin=`` plugins.shift() ``
		extension=${plugin##*.}
		if [[ ${extension} == "py" ]]; then
			python "${PLUGINS_PATH}/${plugin}" --config=$CONFIG_FILE --source=${TEMP_PATH}
		elif [[ ${extension} == "sh" ]]; then
			bash "${PLUGINS_PATH}/${plugin}" -f $CONFIG_FILE -s ${TEMP_PATH}
		fi
		let COUNTER=COUNTER+1
	done

	# Tests
	echo "Execute tests..."
	TESTS_LEN=`` tests.length() ``
	COUNTER=0
	while [  $COUNTER -lt $TESTS_LEN ]; do
		test=`` tests.shift() ``
		extension=${test##*.}
		if [[ ${extension} == "py" ]]; then
			python "${TESTS_PATH}/${test}" --config=$CONFIG_FILE --source=${TEMP_PATH}
		elif [[ ${extension} == "sh" ]]; then
			bash "${TESTS_PATH}/${test}" -d ${TEMP_PATH}
		fi

		# Exit if test fails
		if [[ $? != 0 ]]; then
			echo "A test failed. Generation will not continue"
			exit 1
		fi

		let COUNTER=COUNTER+1
	done

	echo "Tests passed successfully"
	[ -d "${NEW_COIN_PATH}" ] || mkdir -p "${NEW_COIN_PATH}"

	echo "Create patch"
	cd ${WORK_FOLDERS_PATH};
	EXCLUDE_FROM_DIFF="-x '.git'"
	if [ -d "${BASE_COIN_PATH}/build" ]; then
		EXCLUDE_FROM_DIFF="${EXCLUDE_FROM_DIFF} -x 'build'"
	fi
	diff -Naur -x .git ${NEW_COIN_PATH##${WORK_FOLDERS_PATH}/} ${TEMP_PATH##${WORK_FOLDERS_PATH}/} > "${UPDATES_PATH}"  || [ $? -eq 1 ]

	echo "Apply patch"
	[ -d "${NEW_COIN_PATH}" ] || mkdir -p "${NEW_COIN_PATH}"
	if [ ! -z "${UPDATES_PATH}"  ]; then
		# Generate new coin
		cd "${NEW_COIN_PATH}" && patch -s -p1 < "${UPDATES_PATH}" && cd "${SCRIPTS_PATH}"

		bash "${SCRIPTS_PATH}/compile.sh" -c $COMPILE_ARGS -z
	fi
}

# Usage info
show_help() {
cat << EOF
Usage: ${0##*/} [-h] [-f FILE] [-c <string>]
Reads a config file and creates and compiles Cryptonote coin. "config.json" as default

    -h          display this help and exit
    -f          config file
    -c          compile arguments
EOF
}   

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
CONFIG_FILE='config.json'
COMPILE_ARGS='-j'

while getopts "h?f:c:" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    f)  CONFIG_FILE=${OPTARG}
        ;;
    c)  COMPILE_ARGS=${OPTARG}
        ;;
    esac
done

shift $((OPTIND-1))

# Setting config file
if [[ "${CONFIG_FILE}" != /* ]]; then
	CONFIG_FILE="${CONFIG_PATH}/${CONFIG_FILE}"
fi

if [ ! -f ${CONFIG_FILE} ]; then
	echo "ERROR: config file does not exits"	
	exit
fi

# Set config vars
CONFIG=`cat $CONFIG_FILE`

# File
set -f
tickParse "$CONFIG"
set +f

__my_variables=($(set | grep ^__tick_data | awk -F= '{print $1}'))
for __variable in "${__my_variables[@]}"; do
    export "$__variable"
done

if [ -z ``core[genesisCoinbaseTxHex]`` ]; then
	generate_genesis
fi
generate_coin
