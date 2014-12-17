#! /usr/bin/env bash


# Bash script for change coin files

# Exit immediately if an error occurs, or if an undeclared variable is used
set -o errexit


[ "$OSTYPE" != "win"* ] || die "Windows is not supported"

# Set directory vars
. "vars.cfg"  

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.


while getopts "h?f:c:" opt; do
    case "$opt" in
    f)  CONFIG_FILE=${OPTARG}
        ;;
    c)  COMPILE_ARGS=${OPTARG}
        ;;
    esac
done

shift $((OPTIND-1))

if [ -z "${CONFIG_FILE}" ]; then
    exit 1
fi
echo "compile:"
echo ${CONFIG_FILE}
echo ${COMPILE_ARGS}


BUILD_PATH="${WORK_FOLDERS_PATH}/builds"
MAC_BUILD_NAME="${__tick_data_core_CRYPTONOTE_NAME}-mac"
LINUX_BUILD_NAME="${__tick_data_core_CRYPTONOTE_NAME}-linux"
WINDOWS_BUILD_NAME="${__tick_data_core_CRYPTONOTE_NAME}-windows"


cd ${NEW_COIN_PATH}
rm -rf build; mkdir -p build/release; cd build/release

# Compile!
if [[ "$OSTYPE" == "msys" ]]; then
	cmake -DBOOST_ROOT=C:\sdk\boost_1_55_0 -DBOOST_LIBRARYDIR=C:\sdk\boost_1_55_0\lib64-msvc-11.0 -G "Visual Studio 11 Win64" ".."
	msbuild.exe Project.sln /p:Configuration=Release ${COMPILE_ARGS}
else
	cmake -D STATIC=ON -D ARCH="x86-64" -D CMAKE_BUILD_TYPE=Release ../..
	MAKE_STATUS=$( make ${COMPILE_ARGS} )
fi

if [[ $? == "0" ]]; then
	echo "Compilation successful"
fi

# Move and zip binaries
case "$OSTYPE" in
  msys*) 	rm -f ${BUILD_PATH}/${WINDOWS_BUILD_NAME}.zip
	rm -rf ${BUILD_PATH}/${WINDOWS_BUILD_NAME}
	mkdir -p ${BUILD_PATH}/${WINDOWS_BUILD_NAME}
	cp ${NEW_COIN_PATH}/build/release/src/${__tick_data_core_daemon_name} ${BUILD_PATH}/${WINDOWS_BUILD_NAME}
	cp ${NEW_COIN_PATH}/build/release/src/simplewallet ${BUILD_PATH}/${WINDOWS_BUILD_NAME}
	rm -rf "${NEW_COIN_PATH}/build"
	cd ${BUILD_PATH}
	zip -r ${WINDOWS_BUILD_NAME}.zip ${WINDOWS_BUILD_NAME}/
	;;
  darwin*)  	rm -f ${BUILD_PATH}/${MAC_BUILD_NAME}.zip
	rm -rf ${BUILD_PATH}/${MAC_BUILD_NAME}
	mkdir -p ${BUILD_PATH}/${MAC_BUILD_NAME}
	cp ${NEW_COIN_PATH}/build/release/src/${__tick_data_core_daemon_name} ${BUILD_PATH}/${MAC_BUILD_NAME}
	cp ${NEW_COIN_PATH}/build/release/src/simplewallet ${BUILD_PATH}/${MAC_BUILD_NAME}
	rm -rf "${NEW_COIN_PATH}/build"
	cd ${BUILD_PATH}
	zip -r ${MAC_BUILD_NAME}.zip ${MAC_BUILD_NAME}/
	;;
  *)	rm -r ${BUILD_PATH}/${LINUX_BUILD_NAME}.tar.gz
	rm -rf ${BUILD_PATH}/${LINUX_BUILD_NAME}
	mkdir -p ${BUILD_PATH}/${LINUX_BUILD_NAME}
	cp ${NEW_COIN_PATH}/build/release/src/${__tick_data_core_daemon_name} ${BUILD_PATH}/${LINUX_BUILD_NAME}
	cp ${NEW_COIN_PATH}/build/release/src/simplewallet ${BUILD_PATH}/${LINUX_BUILD_NAME}
	rm -rf "${NEW_COIN_PATH}/build"
	cd ${BUILD_PATH}
	tar -zcvf ${LINUX_BUILD_NAME}.tar.gz ${LINUX_BUILD_NAME}
	;;
esac
