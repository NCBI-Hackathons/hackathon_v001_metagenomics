#!/usr/bin/env Rscript
rm(list=ls())
args <- commandArgs(TRUE)
if(length(args)<4){
  stop("Usage: wrapper.R db='viral_refseq.fna' o='outfile' directory1 directory2 ...")
}
viralDb 	= args[1]
outputFile 	= args[2]

# Run sra-blastn
dirs = args[3:length(args)]
for(i in dirs){
	show(sprintf("Running file %s",i))
	cmd = sprintf("blastn.R %s %s",viralDb,paste0(list.files(i,full.names=TRUE)))
	system(cmd)
}
resultNames = sapply(dirs,function(i){
	sub("^([^.]*).*", "\\1", list.files(i)[1])
	})
# check resultNames is not a list
show("Summarizing samples")
sraBlastCmd = sptrinf("summarize_samples %s %s",outputFile,resultNames)
system(sraBlastCmd)

# Run regular blastn

# Run contig blastn