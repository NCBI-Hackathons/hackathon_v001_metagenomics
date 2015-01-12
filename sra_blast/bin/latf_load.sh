#!/bin/sh
# Argument = options SRRXXXX1.fastq SRRXXXX2.fastq ...
# Potentially required to include a tmpfs if running on large
# files in small directory. (--tmpfs /tmp)
usage()
{
cat << EOF
usage: $0 options SRRXXXX1.fastq SRRXXXX2.fastq ...

This script will take a list of fastq/
fasta files and convert them to SRA followed
by a kar file. 

OPTIONS:
   -h      Show this message
   -o      Output sample name - default is 'SRR00000' 
            - sra-blast requires [ESD]RRXXXX file name.
   -e      Number of errors - default 1000000 
   -q      Quality score - default PHRED_33
   -c      Cache-size - default 163840
   -l      Log file name - default 'SRA_Blast_virome_log.txt'
EOF
}
DATE=`date +%Y-%m-%d`
TIME=`date +%H:%M`

OUTPUT='SRR00000'
E='1000000'
Q='PHRED_33'
C='163840'
OPTIND=1
LOG='SRA_Blast_virome_log.txt'

while getopts “ho:e:q:c:l:” OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         o) 
            OUTPUT=$OPTARG
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

echo "Running latf-load at $DATE at $TIME on $OUTPUT" | tee -a $LOG
OPTIONS="-L info -E $E --quality $Q --cache-size $C"
latf-load $OPTIONS -o $OUTPUT.sra $@ >> $LOG 2>&1

echo "Running kar at $DATE at $TIME on $OUTPUT" | tee -a $LOG
kar -c $OUTPUT -d $OUTPUT.sra --force >> $LOG 2>&1
