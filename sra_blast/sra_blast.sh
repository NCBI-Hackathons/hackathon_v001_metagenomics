#!/bin/sh
# Argument = -v viral_refseq.fna SRR00000 SRR00001 SRR00002 SRR00003
usage()
{
cat << EOF
usage: $0 -v viral_refseq.fna SRR00000 SRR00001

This script will convert a directory of fastq
fastq files to SRA and run blast against a
chosen database. Requires -d and -v.

OPTIONS:
   -h      Show this message
   -v      Viral database
   -e      Number of errors - default 1000000 
   -q      Quality score - default PHRED_33
   -c      Cache-size - default 163840
   -v      Verbose. Not implemented yet.   
EOF
}

VIRAL=
DATE=`date +%Y-%m-%d`
TIME=`date +%H:%M`

E='1000000'
Q='PHRED_33'
C='163840'
OPTIND=1
LOG='SRA_Blast_virome_log.txt'

while getopts “hv:e:q:c:l:” OPTION
do
     case $OPTION in
         h)
            usage
            exit 1
            ;;
         v)
            VIRAL=$OPTARG
            ;;
         e) 
            E=$OPTARG
            ;;
         q) 
            Q=$OPTARG
            ;;
         c) 
            C=$OPTARG
            ;;
         l) 
            LOG=$OPTARG
            ;;
         ?)
            usage
            exit
            ;;
     esac
done
shift $(($OPTIND - 1))

if [[ $# == 0 ]]
then
    echo "Requires at least one sample (directory)."
    usage
    exit 1
fi

if [[ !(-z $VIRAL) ]]
then
    for dir in "$@"
    do
        echo "Running the process on $dir at $DATE at $TIME" | tee -a $LOG
        FILES=$(find $dir -name '*.fast[qa]' -exec echo {} \;)
        OUTPUT=$(basename $dir)
        ./bin/latf_load.sh -o SRR.$OUTPUT -e $E -q $Q -c $C -l $LOG $FILES
        ./bin/blastn_vdb_wrapper.sh -v $VIRAL -s SRR.$OUTPUT
    done
    wait

    exit 1
else
 usage
fi

# for i in $(find $dir -name '*.fast[qa]' -exec echo {} \;)
        # do 
        #     echo "hi"
        #     echo $i
        # done
