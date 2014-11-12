#! /usr/bin/env bash

# Starts deployment if change is detected
# Cron cycles this script

# Exit immediately if an error occurs, or if an undeclared variable is used
set -o errexit
set -o nounset

[ "$OSTYPE" != "win"* ] || die "Install Cygwin to use on Windows"

# Set directory vars
. "vars.cfg"
GENERATOR_FILE_PATH="${PROJECT_DIR}/generator.sh"

# Cron cycle period in minutes
CRON_CYCLE='30'
START_DEPLOY=""

# Pull request
echo "git pull base coin"
cd $BASE_COIN_PATH
git reset --hard origin/master
git pull
cd $PROJECT_DIR

# Check if file is changed in _posts folder in the cron cycle
CURRENT_TIMESTAMP="$( date +%s )"
if [[ "$OSTYPE" == "darwin"* ]]; then
	LAST_EDITED_TIMESTAMP="$( stat -f "%m" ${BASE_COIN_PATH} )"
else
	LAST_EDITED_TIMESTAMP="$( stat -c "%Y" ${BASE_COIN_PATH} )"
fi
let TARGET_TIME=${LAST_EDITED_TIMESTAMP}+${CRON_CYCLE}*60

if [[ ${TARGET_TIME} -ge ${CURRENT_TIMESTAMP} ]]; then
	echo "Freshly edited"
	${START_GENERATOR}="$( exec bash "${GENERATOR_FILE_PATH}" )"
fi

echo ${START_GENERATOR}
