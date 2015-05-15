#!/bin/bash

# Initial source: OpenBazaar 
#
# configure.sh - Setup your Dashcoin development environment in one step.
#
# If you are a Ubuntu or MacOSX user, you can try executing this script
# and you already checked out the Dashcoin sourcecode from the git repository
# you can try configuring/installing Dashcoin by simply executing this script
# instead of following the build instructions in the Dashcoin Wiki
# https://github.com/dashcoin/cryptonote-generator.git/wiki/Build-Instructions
#
# This script will only get better as its tested on more development environments
# if you can't modify it to make it better, please open an issue with a full
# error report at https://github.com/dashcoin/cryptonote-generator.git/issues/new
#
# Credits: Dashcoin
#

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

function doneMessage {
  echo "Cryptonote generator configuration finished."
  echo "type 'bash generator.sh [-h] [-f FILE] [-c <string>]' to generate Cryptonote coin."
}

function unsupportedOS {
	echo "Unsupported OS. Only MacOSX and Ubuntu are supported."
}

function installUbuntu {
  # print commands
  set -x

  sudo apt-get update
  sudo apt-get -y install build-essential python-dev gcc-4.8 g++-4.8 git cmake libboost1.55-all-dev

  doneMessage
}

if [[ $OSTYPE == darwin* ]] ; then
	  installMac
elif [[ $OSTYPE == linux-gnu || $OSTYPE == linux-gnueabihf ]]; then
    installUbuntu
else
	  unsupportedOS
fi