#! /usr/bin/env bash


# Bash script for change coin files

# Exit immediately if an error occurs, or if an undeclared variable is used
set -o errexit
set -o nounset


# Set directory vars
. "vars.cfg"

CONFIG_FILE=${1:-${SCRIPTS_PATH}/config.cfg}
CONFIG_FILE_SECURED="${TEMP_PATH}/config.cfg"

# check if the file contains something we don't want
if egrep -q -v '^#|^[^ ]*=[^;]*' "${CONFIG_FILE}"; then
  echo "Config file is unclean, cleaning it..." >&2
  # filter the original to a new file
  egrep '^#|^[^ ]*=[^;&]*'  "${CONFIG_FILE}" > "${CONFIG_FILE_SECURED}"
  CONFIG_FILE="${CONFIG_FILE_SECURED}"
fi

# now source it, either the original or the filtered variant
source "${CONFIG_FILE}"

# Remove temp file
rm -f ${CONFIG_FILE_SECURED}