#! /usr/bin/env bash


# Bash script for change coin files

# Exit immediately if an error occurs, or if an undeclared variable is used
set -o errexit
set -o nounset

[ "$OSTYPE" != "win"* ] || die "Windows is not supported"

# Set directory vars
echo "$(pwd)"
. "vars.cfg"

# Set config vars
. "config-loader.sh"

BUILD_PATH="${WORK_FOLDERS_PATH}/builds"
MAC_BUILD_NAME="${CRYPTONOTE_NAME}-mac"
LINUX_BUILD_NAME="${CRYPTONOTE_NAME}-linux"
WINDOWS_BUILD_NAME="${CRYPTONOTE_NAME}-windows"


cd ${NEW_COIN_PATH}
rm -rf build; mkdir -p build/release; cd build/release

# I do not set -j on linux compile because it breaks
# when I try to compile on fresh installed Ubuntu
MAKE_EXTENSION=''
if [[ "$OSTYPE" == "darwin"* ]]; then
	MAKE_EXTENSION="-j"
fi

# Compile!
if [[ "$OSTYPE" == "msys" ]]; then
	cmake -DBOOST_ROOT=C:\sdk\boost_1_55_0 -DBOOST_LIBRARYDIR=C:\sdk\boost_1_55_0\lib64-msvc-11.0 -G "Visual Studio 11 Win64" ".."
	msbuild.exe Project.sln /p:Configuration=Release
else
	cmake -D STATIC=ON -D ARCH="x86-64" -D CMAKE_BUILD_TYPE=Release ../..
	MAKE_STATUS=$( make ${MAKE_EXTENSION} )
fi

if [[ $? == "0" ]]; then
	echo "Compilation successful"
fi

# Move and zip binaries
case "$OSTYPE" in
  msys*) 	rm -f ${BUILD_PATH}/${WINDOWS_BUILD_NAME}.zip
	rm -rf ${BUILD_PATH}/${WINDOWS_BUILD_NAME}
	mkdir -p ${BUILD_PATH}/${WINDOWS_BUILD_NAME}
	cp ${NEW_COIN_PATH}/build/release/src/${daemon_name} ${BUILD_PATH}/${WINDOWS_BUILD_NAME}
	cp ${NEW_COIN_PATH}/build/release/src/simplewallet ${BUILD_PATH}/${WINDOWS_BUILD_NAME}
	rm -rf "${NEW_COIN_PATH}/build"
	cd ${BUILD_PATH}
	zip -r ${WINDOWS_BUILD_NAME}.zip ${WINDOWS_BUILD_NAME}/
	;;
  darwin*)  	rm -f ${BUILD_PATH}/${MAC_BUILD_NAME}.zip
	rm -rf ${BUILD_PATH}/${MAC_BUILD_NAME}
	mkdir -p ${BUILD_PATH}/${MAC_BUILD_NAME}
	cp ${NEW_COIN_PATH}/build/release/src/${daemon_name} ${BUILD_PATH}/${MAC_BUILD_NAME}
	cp ${NEW_COIN_PATH}/build/release/src/simplewallet ${BUILD_PATH}/${MAC_BUILD_NAME}
	rm -rf "${NEW_COIN_PATH}/build"
	cd ${BUILD_PATH}
	zip -r ${MAC_BUILD_NAME}.zip ${MAC_BUILD_NAME}/
	;;
  *)	rm -r ${BUILD_PATH}/${LINUX_BUILD_NAME}.tar.gz
	rm -rf ${BUILD_PATH}/${LINUX_BUILD_NAME}
	mkdir -p ${BUILD_PATH}/${LINUX_BUILD_NAME}
	cp ${NEW_COIN_PATH}/build/release/src/${daemon_name} ${BUILD_PATH}/${LINUX_BUILD_NAME}
	cp ${NEW_COIN_PATH}/build/release/src/simplewallet ${BUILD_PATH}/${LINUX_BUILD_NAME}
	rm -rf "${NEW_COIN_PATH}/build"
	cd ${BUILD_PATH}
	tar -zcvf ${LINUX_BUILD_NAME}.tar.gz ${LINUX_BUILD_NAME}
	;;
esac
