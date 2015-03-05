#! /usr/bin/env bash


# Bash script for change coin files

# Exit immediately if an error occurs, or if an undeclared variable is used
set -o errexit


[ "$OSTYPE" != "win"* ] || die "Windows is not supported"


# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.


while getopts "c:z" opt; do
    case "$opt" in
    c)  COMPILE_ARGS=${OPTARG}
        ;;
    z)  archive=1
    esac
done
archive=${archive:-0}

shift $((OPTIND-1))

cd ${NEW_COIN_PATH}
rm -rf build; mkdir -p build/release; cd build/release

# Compile!
if [[ "$OSTYPE" == "msys" ]]; then
	cmake -G "Visual Studio 11 Win64" "..\.."
	msbuild.exe Project.sln /property:Configuration=Release ${COMPILE_ARGS}
else
	cmake -D STATIC=ON -D ARCH="x86-64" -D CMAKE_BUILD_TYPE=Release ../..
	make ${COMPILE_ARGS}
fi

if [[ $? == "0" ]]; then
	echo "Compilation successful"
fi

# Move and zip binaries
if [[ $archive == "1" ]]; then
	BUILD_PATH="${WORK_FOLDERS_PATH}/builds"
	MAC_BUILD_NAME="${__CONFIG_core_CRYPTONOTE_NAME}-mac"
	LINUX_BUILD_NAME="${__CONFIG_core_CRYPTONOTE_NAME}-linux"
	WINDOWS_BUILD_NAME="${__CONFIG_core_CRYPTONOTE_NAME}-windows"

	case "$OSTYPE" in
	  msys*) 	rm -f ${BUILD_PATH}/${WINDOWS_BUILD_NAME}.zip
		rm -rf ${BUILD_PATH}/${WINDOWS_BUILD_NAME}
		mkdir -p ${BUILD_PATH}/${WINDOWS_BUILD_NAME}
		cp ${NEW_COIN_PATH}/build/release/src/Release/${__CONFIG_core_daemon_name}.exe ${BUILD_PATH}/${WINDOWS_BUILD_NAME}
		cp ${NEW_COIN_PATH}/build/release/src/Release/simplewallet.exe ${BUILD_PATH}/${WINDOWS_BUILD_NAME}
		cd ${BUILD_PATH}
		zip -r ${WINDOWS_BUILD_NAME}.zip ${WINDOWS_BUILD_NAME}/
		rm -rf "${NEW_COIN_PATH}/build"
		;;
	  darwin*)  	rm -f ${BUILD_PATH}/${MAC_BUILD_NAME}.zip
		rm -rf ${BUILD_PATH}/${MAC_BUILD_NAME}
		mkdir -p ${BUILD_PATH}/${MAC_BUILD_NAME}
		cp ${NEW_COIN_PATH}/build/release/src/${__CONFIG_core_daemon_name} ${BUILD_PATH}/${MAC_BUILD_NAME}
		cp ${NEW_COIN_PATH}/build/release/src/simplewallet ${BUILD_PATH}/${MAC_BUILD_NAME}
		cd ${BUILD_PATH}
		zip -r ${MAC_BUILD_NAME}.zip ${MAC_BUILD_NAME}/
		rm -rf "${NEW_COIN_PATH}/build"
		;;
	  *)	rm -f ${BUILD_PATH}/${LINUX_BUILD_NAME}.tar.gz
		rm -rf ${BUILD_PATH}/${LINUX_BUILD_NAME}
		mkdir -p ${BUILD_PATH}/${LINUX_BUILD_NAME}
		cp ${NEW_COIN_PATH}/build/release/src/${__CONFIG_core_daemon_name} ${BUILD_PATH}/${LINUX_BUILD_NAME}
		cp ${NEW_COIN_PATH}/build/release/src/simplewallet ${BUILD_PATH}/${LINUX_BUILD_NAME}
		cd ${BUILD_PATH}
		tar -zcvf ${LINUX_BUILD_NAME}.tar.gz ${LINUX_BUILD_NAME}
		rm -rf "${NEW_COIN_PATH}/build"
		;;
	esac
fi
