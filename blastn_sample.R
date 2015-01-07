#!/usr/bin/env Rscript
rm(list=ls())
args <- commandArgs(TRUE)

# Assumes that:
# 1. NCBI toolkit is installed and in PATH
#
# 2. The query database (smaller than sample) needs to be called 
#     as the first argument and specifically as db='path/filename' 
#     without spaces
if(length(args)<2){
  stop("Usage: blastn_sample.R db=''viral_refseq.fna'' file1 file2 ...")
}

viralDb = eval(parse(text=args[1]))
files = args[2:length(args)]
fileName = gsub("_[12].fastq","",args[2])
specialName = gsub("SRS","SRR",fileName)

latfOptions = "-L info -E 1000000 --quality PHRED_33 --cache-size 163840 --tmpfs /blast/meta/tmp"
latfCmd = sprintf("latf-load %s -o %s.sra %s > %s.latf.out 2>&1",latfOptions,fileName,paste(files,collapse=" "),fileName)
karCmd  = sprintf("kar -c %sKar -d %s.sra --force",specialName,fileName)
bOptions = "-outfmt '6 qseqid sseqid slen pident length mismatch gapopen qstart qend sstart send evalue bitscore'"
blastCmd = sprintf("blastn_vdb -db %sKar -query %s %s -out %s.blast.results",specialName,viralDb,bOptions,fileName)

print(latfCmd)
system(latfCmd)
print(karCmd)
system(karCmd)
print(blastCmd)
system(blastCmd)
