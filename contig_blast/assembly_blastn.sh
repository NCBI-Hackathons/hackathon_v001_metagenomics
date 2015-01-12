#!/usr/bin/sh
# Argument = -t test -r server -p password -v

# Initialize timestamp variables
DATE=`date +%Y-%m-%d`
TIME=`date +%H:%M`
TM=`date +%Y%m%d-%H%M`
LOG=SRA-Blast_virome_log_$TM.txt

usage()
{
cat << EOF
usage: $0 options

This script run the test1 or test2 over a machine.

OPTIONS:
   -h      Show this message
   -t      Test type, can be ‘test1′ or ‘test2′
   -r      Server address
   -p      Server root password
   -v      Verbose
EOF
}

TEST=
SERVER=
PASSWD=
VERBOSE=
while getopts “ht:r:p:v” OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         t)
             TEST=$OPTARG
             ;;
         r)
             SERVER=$OPTARG
             ;;
         p)
             PASSWD=$OPTARG
             ;;
         v)
             VERBOSE=1
             ;;
         ?)
             usage
             exit
             ;;
     esac
done

if [[ -z $TEST ]] || [[ -z $SERVER ]] || [[ -z $PASSWD ]]
then
     usage
     exit 1
fi
