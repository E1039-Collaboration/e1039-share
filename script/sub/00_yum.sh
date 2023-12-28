#!/bin/bash
##
## All the packages listed here are required for spinquestgpvm as well.
## We have to submit a Services Ticket to install any missing package.
##
if [ ! -e /etc/redhat-release ] ; then
    echo "Cannot find '/etc/redhat-release'."
    echo "Abort since this script assumes Scientific Linux."
    exit 1
fi
if [ ${HOSTNAME:0:6} = udc-ba ] ; then
    echo "No requirement in this script for UVA Rivanna."
    exit 0
fi
if ! grep -q 'Scientific Linux release 7.[6789] ' /etc/redhat-release ; then
    echo "The OS version seems not SL 7.6, 7.7, 7.8 or 7.9."
    echo "Abort since this script assumes this version."
    exit 1
fi

LIST_ALL="$(yum list installed)"

declare -a LIST_PKG=()
while read PKG ; do
    echo "$LIST_ALL" | grep -q "^${PKG}\." || LIST_PKG+=("$PKG")
done <<EOF
  wget
  patch
  libtool
  git-all
  gcc
  gcc-c++
  gcc-gfortran
  boost-devel
  python-devel
  cmake
  doxygen
  mariadb-devel
  sqlite-devel
  ncurses-devel
  zlib-devel
  bzip2-devel
  freetype-devel
  pcre-devel
  xz-devel
  lz4-devel
  libX11-devel
  libXpm-devel
  libXft-devel
  libXext-devel
  fftw-devel
  gsl-devel
  libxml2-devel
  openssl-devel
  libXmu-devel
  xerces-c-devel
  mesa-libGL-devel
  mesa-libGLU-devel
  gl2ps-devel
  xxhash-devel
EOF

if [ ${#LIST_PKG[*]} -eq 0 ] ; then
    echo "All the essential packages have been already installed.  OK."
else
    echo "Some essential packages were found not installed."
    echo "Execute the following command as root:"
    echo "  yum install ${LIST_PKG[*]}"
    exit 1
fi
exit 0
