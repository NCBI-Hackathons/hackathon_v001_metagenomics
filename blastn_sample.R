#!/usr/bin/env Rscript
rm(list=ls())
args <- commandArgs(TRUE)

# Assumes that:
# 1. NCBI toolkit is installed and in PATH
#
# 2. The query database (smaller than sample) needs to be called 
#     as the first argument and specifically as db='path/filename' 
#     without spaces
if(length(args)<3){
  stop("Usage: blastn_sample.R db='viral_refseq.fna' file1 file2 ...")
}
viralDb = eval(parse(text=args[1]))
files = args[2:length(args)]
fileName = sub("^([^.]*).*", "\\1", args[2])
latfCmd = sprintf("latf-load -L info -E 1000000 --quality PHRED_33
           -o %s.sra %s > %s.out 2>&1",fileName,files,fileName)
karCmd  = sprintf("kar -c %s -d %s.sra",rep(fileName,2))

bOptions = "-outfmt '6 qseqid sseqid slen pident length mismatch gapopen qstart qend sstart send
   evalue bitscore'"
blastCmd = sprintf("blastn_vdb -db %s -query %s %s",fileName,viralDb,bOptions)

# Currently in testing mode, to leave testing mode remove the sprintf echo.. 
system(sprtinf("echo %s",latfCmd))
system(sprtinf("echo %s",karCmd))
system(sprtinf("echo %s",blastCmd))