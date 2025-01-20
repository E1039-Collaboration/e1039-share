#!/bin/bash
##
## All the packages listed here are wanted by users on E1039 interactive servers (like e1039gat1).
## This script is not called by `install-all.sh` but should be manually executed on each server to find missing packages.
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
if ! grep -q 'AlmaLinux release 9.[3-9] ' /etc/redhat-release ; then
    echo "The OS version seems not AL 9."
    echo "Abort since this script assumes this version."
    exit 1
fi

LIST_ALL="$(yum list installed)"

declare -a LIST_PKG=()
while read PKG ; do
    echo "$LIST_ALL" | grep -q "^${PKG}\." || LIST_PKG+=("$PKG")
done <<EOF
  emacs
  vim-enhanced
  vim-X11
  xorg-x11-xauth
  netcat
  telnet
  expect
  ImageMagick-c++-devel
  bc
  nano
  screen
  unzip
  zip
  cvs
  evince
  ghostscript
  gv
  mariadb
  numpy
  python3-mysqlclient
  php
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
