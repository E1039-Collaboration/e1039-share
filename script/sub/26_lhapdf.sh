#!/bin/bash
##
## Install LHAPDF, which is wanted by serveral users
## Actually a YUM package "lhapdf-devel" (6.3.0) could be usable.
##
set -e
test -z $DIR_BUILD && exit 9
test -z $DIR_INST  && exit 9
test -e $DIR_INST/lib/libLHAPDF.so && exit

DIR_WORK=$DIR_BUILD/lhapdf
mkdir -p $DIR_WORK
cd       $DIR_WORK

wget --quiet -O LHAPDF-6.2.1.tar.gz 'https://lhapdf.hepforge.org/downloads/?f=LHAPDF-6.2.1.tar.gz'
tar xzf LHAPDF-6.2.1.tar.gz
cd LHAPDF-6.2.1
./configure --disable-python --prefix=$DIR_INST
make
make install

for PDF in CT10nlo CT10 CT14lo CT14nlo MMHT2014lo68cl MMHT2014nlo68cl ; do
    test -e $DIR_INST/share/LHAPDF/$PDF && continue
    wget --quiet https://lhapdf.hepforge.org/downloads?f=pdfsets/v6.backup/6.2/$PDF.tar.gz -O- | tar xz -C $DIR_INST/share/LHAPDF
done
