#! /usr/bin/env bash


# Bash script for automatic generation and deployment

# Exit immediately if an error occurs, or if an undeclared variable is used
set -o errexit

[ "$OSTYPE" != "win"* ] || die "Install MinGW to use on Windows"

# For bold text
if [ "$OSTYPE" != "msys" ]; then
	bold=$(tput bold)
	normal=$(tput sgr0)
fi

# Set directory vars
. "vars.cfg"

# Perform cleanup on exit
function finish {
	# Remove temporary files if exist
	echo "Remove temporary files..."
	rm -f "${UPDATES_PATH}"
	rm -f "${BASH_CONFIG}"
	rm -rf "${TEMP_PATH}"
}
trap finish EXIT

# Generate source code and compile
function generate_coin {
	# Define coin paths
	export BASE_COIN_PATH="${WORK_FOLDERS_PATH}/${__CONFIG_BASE_COIN_extension_folder}"
	export NEW_COIN_PATH="${WORK_FOLDERS_PATH}/${__CONFIG_core_CRYPTONOTE_NAME}"
	if [ -d "${BASE_COIN_PATH}" ]; then
		cd "${BASE_COIN_PATH}"
		echo "Updating ${__CONFIG_BASE_COIN_name}..."
		git checkout master
		git pull
		cd "${PROJECT_DIR}"
	else
		echo "Cloning ${__CONFIG_BASE_COIN_name}..."
		git clone "${__CONFIG_BASE_COIN_git}" "${BASE_COIN_PATH}"
	fi

	if [[ ! -z $BRANCH ]]; then
		cd "${BASE_COIN_PATH}"
		git checkout ${BRANCH}
		cd "${PROJECT_DIR}"
	else
		cd "${BASE_COIN_PATH}"
		git checkout ${__CONFIG_BASE_COIN_branch}
		cd "${PROJECT_DIR}"
	fi

	# Install dependencies
	echo "Installing dependencies..."
	export __CONFIG_BASE_COIN_dependencies_text="${__CONFIG_BASE_COIN_dependencies[@]}"
	for dependency in "${__CONFIG_BASE_COIN_dependencies[@]}"
	do
		dependency_dir=$(basename $dependency)
		DEPENDENCY_PATH="${WORK_FOLDERS_PATH}/${dependency_dir}"

		if [ -d "${DEPENDENCY_PATH}" ]; then
			cd "${DEPENDENCY_PATH}"
			echo "Updating dependency ${dependency}..."
			git pull
			cd "${PROJECT_DIR}"
		else
			echo "Cloning dependency ${dependency}..."
			git clone "${dependency}" "${DEPENDENCY_PATH}"
		fi
	done

	# Exit if base coin does not exists
	if [ ! -d "${BASE_COIN_PATH}" ]; then
		echo "Base coin does not exist"
		echo "Abort clone generation"
		exit 4
	fi

	echo "Make temporary ${__CONFIG_BASE_COIN_name} copy..."
	[ -d "${TEMP_PATH}" ] || mkdir -p "${TEMP_PATH}"
	cp -af "${BASE_COIN_PATH}/." "${TEMP_PATH}"

	# Extensions
	echo "Personalize base coin source..."
	export __CONFIG_extensions_text="${__CONFIG_extensions[@]}"
	for extension in "${__CONFIG_extensions[@]}"
	do
		echo "${bold}Execute ${EXTENSIONS_PATH}/${__CONFIG_BASE_COIN_extension_folder}/${extension}${normal}"
		python "lib/file-modification.py" --extension "${EXTENSIONS_PATH}/${__CONFIG_BASE_COIN_extension_folder}/${extension}" --config=$CONFIG_FILE --source=${TEMP_PATH}
	done

	[ -d "${NEW_COIN_PATH}" ] || mkdir -p "${NEW_COIN_PATH}"

	echo "Create patch"
	cd "${WORK_FOLDERS_PATH}";
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
        chmod -R 755 ${NEW_COIN_PATH}

		bash "${SCRIPTS_PATH}/compile.sh" -c "${COMPILE_ARGS}" -z
	fi

	if [[ ! -z $BRANCH ]]; then
		cd "${BASE_COIN_PATH}"
		git checkout master
	fi
}

# Usage info
show_help() {
cat << EOF
Usage: ${0##*/} [-h] [-f FILE] [-c <string>]
Reads a config file and creates and compiles Cryptonote coin. "config.json" as default

    -h          display this help and exit
    -f          config file
    -b          branch
    -c          compile arguments
EOF
}

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
CONFIG_FILE='config.json'
CORE_CONFIG_FILE=''
COMPILE_ARGS=''

while getopts "h?f:b:c:" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    f)  CONFIG_FILE=${OPTARG}
        ;;
    b)  BRANCH=${OPTARG}
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

[ -d "${WORK_FOLDERS_PATH}" ] || mkdir -p "${WORK_FOLDERS_PATH}"

# Get environment environment_variables
python "lib/environment_variables.py" --config=$CONFIG_FILE --output=$BASH_CONFIG
if [ ! -f ${BASH_CONFIG} ]; then
	echo "Config file was not translated to bash."
	echo "Abort coin generation"
	exit 3
fi
source ${BASH_CONFIG}

CORE_CONFIG_FILE=${__CONFIG_base_coin}
# Setting core config file
if [[ "${CORE_CONFIG_FILE}" != /* ]]; then
	CORE_CONFIG_FILE="${CORE_CONFIG_PATH}/cores/${CORE_CONFIG_FILE}.json"
fi

if [ ! -f ${CORE_CONFIG_FILE} ]; then
	echo "ERROR: core config file does not exits"
	echo "${CORE_CONFIG_FILE}"
	exit
fi

# Get environment environment_variables
python "lib/environment_variables.py" --config=$CORE_CONFIG_FILE --output=$BASH_CONFIG --prefix="_BASE_COIN"
if [ ! -f ${BASH_CONFIG} ]; then
	echo "Core config file was not translated to bash."
	echo "Abort coin generation"
	exit 3
fi
source ${BASH_CONFIG}

generate_coin
