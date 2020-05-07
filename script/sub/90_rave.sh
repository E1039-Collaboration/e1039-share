#!/bin/bash
##
## Install rave, for vertex finding and fitting
##
set -e
test -z $DIR_BUILD && exit 9
test -z $DIR_INST  && exit 9
test -e $DIR_INST/lib/libRaveBase.a && exit

source $DIR_INST/this-share.sh

DIR_DAT=$(readlink -f ${0%'.sh'})
DIR_WORK=$DIR_BUILD/rave
mkdir -p $DIR_WORK
cd       $DIR_WORK

git clone https://github.com/E1039-Collaboration/rave.git
cd    rave
git checkout 3e19ef3b19958d52b8f0c461ab452aebb10ac1e1

./bootstrap
./configure --prefix=$DIR_INST --with-clhep=$DIR_INST --disable-java
make -j4
make install
