#!/bin/bash
##
## Install GenFit, which is required by e1039-core/packages/PHGenFitPkg
##
set -e
test -z $DIR_BUILD && exit 9
test -z $DIR_INST  && exit 9
test -e $DIR_INST/lib/libgenfit2.so && exit

source $DIR_INST/this-share.sh
export RAVEPATH=$DIR_BUILD/rave/rave

DIR_DAT=$(readlink -f ${0%'.sh'})
DIR_WORK=$DIR_BUILD/genfit
rm -rf   $DIR_WORK
mkdir -p $DIR_WORK
cd       $DIR_WORK

git clone https://github.com/E1039-Collaboration/GenFit.git
mkdir GenFit-build
cd    GenFit
git checkout c94316de60714f9e8a9bd180b4e9ca0948688dac
patch -p0 <$DIR_DAT/patch.txt  # Made by Abinash, DocDB 7650
cd ../GenFit-build

# The "-DINCLUDE_OUTPUT_DIRECTORY:PATH" option is needed because
# the PHGenFitPkg package assumes the header files are in "include/GenFit/".
# In the future it is better to modify the PHGenFitPkg package 
# so that this special option is not needed.
cmake -DCMAKE_INSTALL_PREFIX=$DIR_INST -DINCLUDE_OUTPUT_DIRECTORY:PATH=$DIR_INST/include/GenFit ../GenFit
make
make install
