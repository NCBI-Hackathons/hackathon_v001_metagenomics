#!/usr/bin/env Rscript
rm(list=ls())
args <- commandArgs(TRUE)
if(length(args)<4){
  stop("Usage: wrapper.R db='viral_refseq.fna' o='outfile' directory1 directory2 ...")
}
viralDb 	= eval(parse(text=args[1]))
outputFile 	= eval(parse(text=args[2]))

# Run sra-blastn
dirs = args[3:length(args)]
for(i in dirs){
	print(sprintf("Running file %s",i))
	cmd = sprintf("Rscript hackathon_v001_metagenomics/blastn_sample.R db='%s' %s",viralDb,paste(grep("fastq",list.files(i,full.names=TRUE),value=TRUE)))
	print(cmd)
	system(cmd)
}
resultNames = sapply(dirs,function(i){
	sub("^([^.]*).*", "\\1", list.files(i)[1])
	})
# check resultNames is not a list
print("Summarizing samples")
sraBlastCmd = sprintf("Rscript hackathon_v001_metagenomics/summarize_samples.R o='%s' %s",outputFile,resultNames)
system(sraBlastCmd)

# Run regular blastn

# Run contig blastn
