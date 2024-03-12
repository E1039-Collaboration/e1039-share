#!/bin/bash
##
## Install a recent cmake version
##
set -e
test -z $DIR_BUILD && exit 9
test -z $DIR_INST  && exit 9
test -e $DIR_INST/bin/cmake && exit

if [ ${HOSTNAME:0:6} = udc-ba ] ; then
    echo "No requirement in this script for UVA Rivanna."
    exit 0
fi

DIR_WORK=$DIR_BUILD/cmake
mkdir -p $DIR_WORK
cd       $DIR_WORK
wget --quiet https://github.com/Kitware/CMake/releases/download/v3.13.4/cmake-3.13.4.tar.gz
tar xzf cmake-3.13.4.tar.gz
cd cmake-3.13.4
./bootstrap --prefix=$DIR_INST
make
make install
