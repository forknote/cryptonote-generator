#!/bin/bash

# Template: OpenBazaar 
#
# install_dependencies.sh - Setup your Cryptonote development environment in one step.
#
# This script will only get better as its tested on more development environments
# if you can't modify it to make it better, please open an issue with a full
# error report at https://github.com/forknote/cryptonote-generator.git/issues/new
#
# Credits: Forknote
#
# Code borrowed from:
# https://github.com/OpenBazaar/OpenBazaar/blob/develop/configure.sh
# https://github.com/Quanttek/install_monero/blob/master/install_monero.sh

#exit on error
set -e

function command_exists {
  # this should be a very portable way of checking if something is on the path
  # usage: "if command_exists foo; then echo it exists; fi"
  type "$1" &> /dev/null
}

function brewDoctor {
    if ! brew doctor; then
      echo ""
      echo "'brew doctor' did not exit cleanly! This may be okay. Read above."
      echo ""
      read -p "Press [Enter] to continue anyway or [ctrl + c] to exit and do what the doctor says..."
    fi
}

function brewUpgrade {
    echo "If your homebrew packages are outdated, we recommend upgrading them now. This may take some time."
    read -r -p "Do you want to do this? [y/N] " response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
    then
      if ! brew upgrade; then
        echo ""
        echo "There were errors when attempting to 'brew upgrade' and there could be issues with the installation of Cryptonote generator."
        echo ""
        read -p "Press [Enter] to continue anyway or [ctrl + c] to exit and fix those errors."
      fi
    fi
}

function installMac {
  # print commands (useful for debugging)
  # set -x  #disabled because the echos and stdout are verbose enough to see progress

  # install brew if it is not installed, otherwise upgrade it
  if ! command_exists brew ; then
    echo "installing brew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
    echo "updating, upgrading, checking brew..."
    brew update
    brewDoctor
    brewUpgrade
    brew prune
  fi

  # install gpg/sqlite3/python/wget/openssl/zmq if they aren't installed
  for dep in cmake boost python
  do
    if ! command_exists $dep ; then
      brew install $dep
    fi
  done

  doneMessage
}

function unsupportedOS {
	echo "Unsupported OS. Only MacOSX and Ubuntu are supported."
}

function installUbuntu {
  . /etc/lsb-release

  # print commands
  set -x

  if [[ $DISTRIB_ID=Ubuntu && $DISTRIB_RELEASE == 16.04 ]] ; then
    sudo apt-get update
    sudo apt-get -y install build-essential python-dev gcc-4.9 g++-4.9 git cmake libboost1.58-all-dev librocksdb-dev
    export CXXFLAGS="-std=gnu++11"

    doneMessage
  elif [[ $DISTRIB_ID=Ubuntu && $DISTRIB_RELEASE == 16.10 ]] ; then
    sudo apt-get update
    sudo apt-get -y install build-essential python-dev gcc-4.9 g++-4.9 git cmake libboost1.61-all-dev librocksdb-dev
    export CXXFLAGS="-std=gnu++11"

    doneMessage
  else
    echo "Only Ubuntu 16.04 is supported"
  fi
}

function doneMessage {
  echo "Cryptonote generator configuration finished."
  echo "type 'bash generator.sh [-h] [-f FILE] [-c <string>]' to generate Cryptonote coin."
}

if [[ $OSTYPE == darwin* ]] ; then
	  installMac
elif [[ $OSTYPE == linux-gnu || $OSTYPE == linux-gnueabihf ]]; then
    installUbuntu
else
	  unsupportedOS
fi