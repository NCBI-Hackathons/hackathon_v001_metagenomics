#!/bin/sh
# Argument = -v viral_refseq.fna SRR00000 SRR00001 ...
usage()
{
cat << EOF
usage: $0 options -v viral_refseq.fna SRR00000 SRR00001


This script will convert sample directories of fastq
and fasta files into SRA format and then KAR format
and run blastn_vdb against a chosen database. Requires -v.
See also summarize_samples.R to convert results into an 
abundance matrix.

Warning: directories must be named [ESD]RRXXXXX currently


OPTIONS:
   -h      Show this message
   -v      Viral database (required)
   -n      Numner of cores to parallelize samples - default 1
   -p      Number of threads for blastn - default 1
   -e      Number of errors - default 1000000 (latf-load option)
   -q      Quality score - default PHRED_33 (latf-load option)
   -c      Cache-size - default 163840 (latf-load option)
   -l      Log file name - default SRA_Blast_virome_log.txt
EOF
}

VIRAL=
OPTIND=1
N=1
P=1

E='1000000'
Q='PHRED_33'
C='163840'

DATE=`date +%Y-%m-%d`
TIME=`date +%H:%M`
LOG='SRA_Blast_virome_log.txt'

while getopts “hv:n:p:e:q:c:l:” OPTION
do
     case $OPTION in
         h)
            usage
            exit 1
            ;;
         v)
            VIRAL=$OPTARG
            ;;
         n) 
            N=$OPTARG
            ;;
         p) 
            P=$OPTARG
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

if [[ !(-z $VIRAL) && ($N -eq 1) ]]; then
    for dir in "$@"
    do
        echo "Running the process on $dir at $DATE at $TIME" | tee -a $LOG
        FILES=$(find $dir -name '*.fast[qa]' -exec echo {} \;)
        OUTPUT=$(basename $dir)
        latf_load.sh -o $OUTPUT -e $E -q $Q -c $C -l $LOG $FILES
        blastn_vdb_wrapper.sh -v $VIRAL -s $OUTPUT -p $P
    done
    wait

    exit 1
elif [[ !(-z $VIRAL) && ($N -gt 1) ]]; then
    echo "Not implemented yet"
else
 usage
fi


# for i in $(find $dir -name '*.fast[qa]' -exec echo {} \;)
        # do 
        #     echo "hi"
        #     echo $i
        # done
