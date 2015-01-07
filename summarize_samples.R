#!/usr/bin/env Rscript
rm(list=ls())
args <- commandArgs(TRUE)

# Assumes output from 'blastn_sample.R'
# Really it's just blast outfmt = 6 and first column = qseqid.
#
# Assumes (which it shouldn't pragmatically) first argument is
# 	the name for outfile and specifically called as o='path/filename' 
#   without spaces.
if(length(args)<1){
  stop("Usage: summarize_samples.R file1 file2 ...")
}
fileNames = basename(args)
fileResults = lapply(args,function(i){
		tryCatch(read.csv(i,header=FALSE,stringsAsFactors=FALSE,"\t"),error=function(e){})
	})
virusesFound = lapply(fileResults,function(i){
		table(i[,1])
	})
names(virusesFound) = fileNames
vlist = c()
for(i in 1:length(virusesFound)){
	vlist = c(vlist,names(virusesFound[[i]]))
}
vlist = unique(vlist)
countMatrix = array(0,dim=c(length(vlist),length(fileNames)))
colnames(countMatrix) = fileNames
rownames(countMatrix) = vlist

for(i in fileNames){
	countMatrix[names(virusesFound[[i]]),i] = virusesFound[[i]]
}
write.table(countMatrix,sep="\t",file="results.tsv",quote=FALSE,row.names=TRUE,col.names=TRUE)
