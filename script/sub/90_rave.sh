#!/bin/bash
##
## Install rave, for vertex finding and fitting
##
set -e
test -z $DIR_BUILD && exit 9
test -z $DIR_INST  && exit 9
test -e $DIR_INST/lib/libRaveBase.a && exit

source $DIR_INST/this-share.sh

DIR_WORK=$DIR_BUILD/rave
mkdir -p $DIR_WORK
cd       $DIR_WORK

git clone https://github.com/E1039-Collaboration/rave.git
cd    rave
git checkout e232f40c84b2263b29f8496da2353bde550dfd26

./bootstrap
./configure --prefix=$DIR_INST --with-clhep=$DIR_INST --disable-java
make -j4
make install
