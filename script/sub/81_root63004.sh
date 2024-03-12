#!/bin/bash
##
## Install ROOT
##
set -e
test -z $DIR_BUILD && exit 9
test -z $DIR_INST  && exit 9
test -e $DIR_INST/root/bin/thisroot.sh && exit

export LC_ALL=C
# Set the locale.  If it was "ja_JP.UTF-8", the error "Cannot determine
# location of C++ headers for runtime" occured in
# "root-6.16.00-src/interpreter/cling/lib/Interpreter/CMakeLists.txt"!!!

DIR_WORK=$DIR_BUILD/root63004
mkdir -p $DIR_WORK
cd       $DIR_WORK
wget --quiet https://root.cern/download/root_v6.30.04.source.tar.gz
tar xzf root_v6.30.04.source.tar.gz
mkdir build
cd    build

if [ -e /usr/lib/libgif.so -a ! -e /usr/lib64/libgif.so ] ; then
    OPT_EXTRA='-DGIF_INCLUDE_DIR= -DGIF_LIBRARY='
    # This case happens when the i686 package of "giflib-devel" is installed
    # but the x86_64 one isn't.  Indeed "spinquestgpvm" is in such situation.
    # Without these options, cmake tries to link the i686 file and thus fails.
fi
cmake -DCMAKE_INSTALL_PREFIX=$DIR_INST/root -Dminuit2=on -Droofit=on -Dopengl=on -Ddavix=off $OPT_EXTRA ../root-6.30.04
cmake --build . --target install -- -j6

if [ "$SINGULARITY_NAME" -o ${HOSTNAME:0:13} = 'spinquestgpvm' ] ; then
    ## Reduce the number of files to mitigate the load on CVMFS.
    rm -r $DIR_INST/root/{man,test,tutorials}
fi
