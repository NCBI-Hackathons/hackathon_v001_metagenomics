#!/usr/bin/env Rscript
rm(list=ls())
args <- commandArgs(TRUE)

# Assumes output from 'blastn_sample.R'
# Really it's just blast outfmt = 6 and first column = qseqid.
#
# Assumes (which it shouldn't pragmatically) first argument is
# 	the name for outfile and specifically called as o='path/filename' 
#   without spaces.
if(length(args)<3){
  stop("Usage: summarize_samples.R o='outfile' file1 file2 ...")
}
outputFile = paste(eval(parse(text=args[1])),".tsv",sep="")
fileNames = sub("^([^.]*).*", "\\1", args)
fileResults = lapply(args,function(i){
		read.csv(i,header=FALSE,stringsAsFactors=FALSE)
	})
virusesFound = lapply(fileResults,function(i){
		table(i[,1])
	})
names(virusesFound) = fileNames
vlist = unique(sapply(virusesFound,names))
countMatrix = array(NA,dim=c(length(vlist),length(fileNames)))
colnames(countMatrix) = fileNames
rownames(countMatrix) = vlist

for(i in fileNames){
	countMatrix[names(virusesFound[[i]]),i] = virusesFound[[i]]
}
write.table(countMatrix,sep="\t",file=outputFile,quote=FALSE,rownames=TRUE,colnames=TRUE)