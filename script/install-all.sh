#!/bin/bash
DIR_SCRIPT=$(dirname $(readlink -f $0))

if [ -z $DIR_INST ] ; then
    echo "The shell environment is not ready for installation."
    echo "Please refer to 'README.md'.  Abort."
    exit 1
fi

for FN_SH in $DIR_SCRIPT/sub/[0-9][0-9]_*.sh ; do
    FN_LOG=$DIR_TOP/log/log_$(basename $FN_SH .sh).txt
    mkdir -p $DIR_TOP/log
    echo "----------------------------------------------------------------"
    echo "Script: $FN_SH"
    echo "----------------"
    $FN_SH 2>&1 | tee $FN_LOG
    RET=${PIPESTATUS[0]} ## = exit status of the '$FN_SH' command above
    if [ $RET -ne 0 ] ; then
	echo "Abort as '$FN_SH' returned '$RET'."
	echo "Check details in '$FN_LOG'."
	exit $RET
    fi
done
echo "----------------------------------------------------------------"
echo "All have finished.  Congratulations!!"

{
    echo "The e1039-share package:"
    echo "Installed with $DIR_TOP"
    echo "          by $USER"
    echo "          on $HOSTNAME"
    echo "          at $(date)."
} >>$DIR_INST/install.txt
