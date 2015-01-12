#!/bin/sh
# Argument = options -s sample -v viral.faa
usage()
{
cat << EOF
usage: $0 options -s sample -v viral.faa

This script will take a list of fastq/
fasta files and convert them to SRA followed
by a kar file. 

OPTIONS:
   -h      Show this message
   -s      Sample name - sra-blast requires a kar file [ESD]RR file
            without the .kar extension
   -v      Viral database
   -l      Log file name - default 'SRA_Blast_virome_log.txt'
EOF
}
DATE=`date +%Y-%m-%d`
TIME=`date +%H:%M`

VIRAL=
SAMPLE=
LOG='SRA_Blast_virome_log.txt'

while getopts “hs:v:l:” OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         s) 
            SAMPLE=$OPTARG
            ;;
         v) 
            VIRAL=$OPTARG
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

if [[ !(-z $VIRAL) && !(-z $SAMPLE) ]]
then
    BOPTIONS="-outfmt '6 qseqid sseqid slen pident length mismatch gapopen qstart qend sstart send evalue bitscore'"
    echo "Running blastn_vdb at $DATE at $TIME on $SAMPLE" | tee -a $LOG
    blastn_vdb -db $SAMPLE -query $VIRAL $BOPTIONS -out $SAMPLE.blast.results
    exit 1
else
 usage
fi