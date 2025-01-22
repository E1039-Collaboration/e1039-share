#!/bin/bash
##
## Install GenFit, which is required by e1039-core/packages/PHGenFitPkg
##
test -z $DIR_BUILD && exit 9
test -z $DIR_INST  && exit 9
test -e $DIR_INST/lib64/libgenfit2.so && exit

source $DIR_INST/this-share.sh
#export RAVEPATH=$DIR_BUILD/rave/rave

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

OPT_TEST=
if [ ${HOSTNAME:0:6} = udc-ba ] ; then
    echo "Set BUILD_TESTING=false at UVA Rivanna."
    OPT_TEST='-DBUILD_TESTING=false'
fi

# The "-DINCLUDE_OUTPUT_DIRECTORY:PATH" option is needed because
# the PHGenFitPkg package assumes the header files are in "include/GenFit/".
# In the future it is better to modify the PHGenFitPkg package 
# so that this special option is not needed.
cmake ../GenFit -DLIBRARY_OUTPUT_DIRECTORY:PATH=$DIR_INST/lib64 -DINCLUDE_OUTPUT_DIRECTORY:PATH=$DIR_INST/include/GenFit -DCMAKE_INSTALL_PREFIX=$DIR_INST $OPT_TEST
make
make install

# Install rdict and pcm files manually 
cp -a *.rootmap *.pcm lib/* $DIR_INST/lib64/
