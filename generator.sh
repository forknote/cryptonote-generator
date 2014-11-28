#! /usr/bin/env bash


# Bash script for automatic generation and deployment

# Exit immediately if an error occurs, or if an undeclared variable is used
set -o errexit
set -o nounset

[ "$OSTYPE" != "win"* ] || die "Install Cygwin to use on Windows"

# Set directory vars
. "vars.cfg"

# Perform cleanup on exit
function finish {
	# Remove temporary files if exist
	echo "Remove temporary files..."
	rm -f "${UPDATES_PATH}"
	rm -rf "${TEMP_PATH}"
}
trap finish EXIT

# Usage info
show_help() {
cat << EOF
Usage: ${0##*/} [-hc] [FILE]...
Reads a config FILE and generates source code. With no FILE
use 'config.json' as default
    
    -h          display this help and exit
    -c          compile the generated source
EOF
}   

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
COMPILE=0

while getopts "h?c" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    c)  COMPILE=1
        ;;
    esac
done

shift $((OPTIND-1))

# Setting config file
CONFIG_FILE=${@:-${SCRIPTS_PATH}/config.json}
if [[ "${CONFIG_FILE}" != /* ]]; then
	CONFIG_FILE="${SCRIPTS_PATH}/${CONFIG_FILE}"
fi

if [ ! -f ${CONFIG_FILE} ]; then
	echo "ERROR: config file does not exits"	
	exit
fi

if [ -d "${BASE_COIN_PATH}" ]; then
	echo "Updating Bytecoin..."
	git pull
else
	echo "Cloning Bytecoin..."
	git clone https://github.com/amjuarez/bytecoin.git "${BASE_COIN_PATH}"
fi

echo "Make temporary base coin copy..."
[ -d "${TEMP_PATH}" ] || mkdir -p "${TEMP_PATH}"
cp -af "${BASE_COIN_PATH}/." "${TEMP_PATH}"

echo "Personalize base coin source..."
python "${SCRIPTS_PATH}/plugins/core/bytecoin-core.py" --config=$CONFIG_FILE --source=${TEMP_PATH}

# Tests
bash "${SCRIPTS_PATH}/customize-test.sh" $CONFIG_FILE
if [[ $? != 0 ]]; then
	echo "A test failed. Deployment will not continue"
	exit 1
fi

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

	bash "${SCRIPTS_PATH}/compile.sh"
fi
