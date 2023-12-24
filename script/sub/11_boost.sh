#!/bin/bash
##
## C++ Boost, which is not available on OSG.
##
set -e
test -z $DIR_BUILD && exit 9
test -z $DIR_INST  && exit 9
test -e $DIR_INST/include/boost && exit

if [ ${HOSTNAME:0:6} != udc-ba ] ; then
    echo "Do nothing since host != udc-ba."
    exit 0
fi

DIR_WORK=$DIR_BUILD/boost
mkdir -p $DIR_WORK
cd       $DIR_WORK
wget --quiet -O boost_1_53_0.tar.bz2 https://sourceforge.net/projects/boost/files/boost/1.53.0/boost_1_53_0.tar.bz2/download
tar xjf boost_1_53_0.tar.bz2
cd boost_1_53_0
./bootstrap.sh --prefix=$DIR_INST

set +e ## We know b2 returns 1 but it seems fine.
./b2
./b2 install
return 0

# The version selected here is very old but is the one in SLF 7.6...

