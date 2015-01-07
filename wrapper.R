#!/usr/bin/env Rscript
download_not_installed<-function(x){
	for(i in x){
		if(!require(i,character.only=TRUE)){
	  		install.packages(i,repos="http://cran.r-project.org")
  			library(i,character.only=TRUE)
  		}
	}
}
download_not_installed(doParallel)
rm(list=ls())
args <- commandArgs(TRUE)
if(length(args)<3){
  stop("Usage: wrapper.R db=''viral_refseq.fna'' directory1 directory2 ...")
}
bin = "hackathon_v001_metagenomics"
cores = 12
viralDb = eval(parse(text=args[1]))

cl = makeCluster(cores)
registerDoParallel(cl)

# Run sra-blastn
dirs = args[2:length(args)]
resultNames = dirs

foreach(i=1:length(dirs)) %dopar% {
	print(sprintf("Running file %s",dirs[i]))
	dirFiles = paste(grep("fastq",list.files(dirs[i],full.names=TRUE),value=TRUE),collapse=" ")
	cmd = sprintf("Rscript %s/blastn_sample.R db=\"'%s'\" %s",bin,viralDb,dirFiles)
	system(cmd)
}
# check resultNames is not a list
#print("Summarizing samples")
#sraBlastCmd = sprintf("Rscript %s/summarize_samples.R o=\"'%s'\" %s",bin,outputFile,resultNames)
#print(sraBlastCmd)
#system(sraBlastCmd)

# Run regular blastn

# Run contig blastn
