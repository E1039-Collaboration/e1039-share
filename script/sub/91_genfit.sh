#!/bin/bash
##
## Install GenFit, which is required by e1039-core/packages/PHGenFitPkg
##
test -z $DIR_BUILD && exit 9
test -z $DIR_INST  && exit 9
test -e $DIR_INST/lib64/libgenfit2.so && exit

source $DIR_INST/this-share.sh
export RAVEPATH=$DIR_BUILD/rave/rave

set -e

DIR_WORK=$DIR_BUILD/genfit
rm -rf   $DIR_WORK
mkdir -p $DIR_WORK
cd       $DIR_WORK

git clone https://github.com/E1039-Collaboration/GenFit.git
mkdir GenFit-build
cd    GenFit
git checkout e1039-al9
cd ../GenFit-build

# The "-DINCLUDE_OUTPUT_DIRECTORY:PATH" option is needed because
# the PHGenFitPkg package assumes the header files are in "include/GenFit/".
# In the future it is better to modify the PHGenFitPkg package 
# so that this special option is not needed.
#cmake -DCMAKE_INSTALL_PREFIX=$DIR_INST -DINCLUDE_OUTPUT_DIRECTORY:PATH=$DIR_INST/include/GenFit ../GenFit
#make
#make install

cmake ../GenFit
make

# Install files manually since 'make install' runs forever...
cp -a lib/* $DIR_INST/lib64/
mkdir -p $DIR_INST/include/GenFit
cp -a ../GenFit/core/include/* $DIR_INST/include/GenFit/
