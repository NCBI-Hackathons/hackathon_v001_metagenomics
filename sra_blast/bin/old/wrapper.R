#!/usr/bin/env Rscript
rm(list=ls())
args <- commandArgs(TRUE)
if(length(args)<3){
  stop("Usage: wrapper.R db=''viral_refseq.fna'' directory1 directory2 ...")
}
bin = "hackathon_v001_metagenomics"
cores = 15
viralDb = eval(parse(text=args[1]))

download_not_installed<-function(x){
        for(i in x){
                if(!require(i,character.only=TRUE)){
                        install.packages(i,repos="http://cran.r-project.org")
                        library(i,character.only=TRUE)
                }
        }
}
download_not_installed("doParallel")

# Run sra-blastn
dirs = args[2:length(args)]
resultNames = dirs

cl = makeCluster(cores)
registerDoParallel(cl)

foreach(i=1:length(dirs)) %dopar% {
	print(sprintf("Running file %s",dirs[i]))
	dirFiles = paste(grep("fastq",list.files(dirs[i],full.names=TRUE),value=TRUE),collapse=" ")
	cmd = sprintf("Rscript %s/blastn_sample.R db=\"'%s'\" %s",bin,viralDb,dirFiles)
	system(cmd)
}

stopCluster(cl)

print("Summarizing samples into results.tsv")
blastFiles = paste(paste(resultNames,"*blast.results",sep="/"),collapse=" ")
sraBlastCmd = sprintf("Rscript %s/summarize_samples.R %s",bin,blastFiles)
print(sraBlastCmd)
system(sraBlastCmd)

print("regular blastn")
# Run regular blastn

print("contig blastn")
# Run contig blastn
