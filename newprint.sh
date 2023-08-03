#!/bin/bash

if [ -z "$1" ]
then
    echo "No argument supplied"
    exit
fi

INPUT_FILE=$(cd $(dirname $1) && pwd)/$(basename $1)
INPUT_FILE_B64="/tmp/newprint_"`echo $INPUT_FILE | base64 -w 0`

if [ ! -f $INPUT_FILE_B64 ]
then
    touch $INPUT_FILE_B64
fi

PREVIOUS_NO_LINES=$((`cat $INPUT_FILE_B64`))
CURRENT_NO_LINES=$((`cat $INPUT_FILE | wc -l`))

if [ -z "${PREVIOUS_NO_LINES}" ] || [ $CURRENT_NO_LINES -lt $PREVIOUS_NO_LINES ];
then
    awk -v INPUT_FILE_B64=$INPUT_FILE_B64 '{print} END {print NR > INPUT_FILE_B64 }' $INPUT_FILE
else
    awk -v PREVIOUS_NO_LINES=$PREVIOUS_NO_LINES -v INPUT_FILE_B64=$INPUT_FILE_B64 '{if (NR>PREVIOUS_NO_LINES) print} END {print NR > INPUT_FILE_B64 }' $INPUT_FILE
fi
