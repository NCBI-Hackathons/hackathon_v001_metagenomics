#!/usr/bin/sh

# Initialize timestamp variables
DATE=`date +%Y-%m-%d`
TIME=`date +%H:%M`
TM=`date +%Y%m%d-%H%M`
LOG=Blast_virome_log_$TM.txt

READS1=$1
READS2=$2
DB=$3
#Create log file
echo "Executing Assembly using Abyss on $DATE at $TIME " | tee $LOG
abyss-pe name=assembly k=25 in='$READS1 $READS2' np=30 | tee -a $LOG

echo "Executing make blast DB on $DATE at $TIME " | tee -a $LOG
makeblastdb -in $DB -dbtype 'nucl' -out ./DB_out

echo "Executing blasting contig on $DATE at $TIME " | tee -a $LOG
blastn -task blastn -db $DB -query assembly-contigs.fa -out assembly_contigs_vs_retrovirus.blast -outfmt '6 qseqid sseqid slen pident length mismatch gapopen qstart qend sstart send evalue bitscore' -num_threads 30 | tee -a $LOG