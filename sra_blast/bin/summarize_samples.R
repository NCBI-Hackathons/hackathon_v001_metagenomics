#!/usr/bin/env Rscript
rm(list=ls())
args <- commandArgs(TRUE)

# Input:
# 	Blast results for any number of samples
# Assumes output from 'sra_blast.sh' or 'blastn_vdb_wrapper.sh' 
# Input requires the first column represents the row name (query sequence id) of a sample.
# In particular, the output of the blast results are outfmt = 6 and first column = qseqid.
#
# Output:
# 	results.tsv - tab delimited file where rows are features, columns are samples
#			and each cell represents the number of hits for a given feature/sample.
#
if(length(args)<1){
  stop("Usage: Rscript summarize_samples.R file1 file2 ...")
}
fileNames = basename(args)
fileResults = lapply(args,function(i){
		tryCatch(read.csv(i,header=FALSE,stringsAsFactors=FALSE,"\t"),error=function(e){print(e)})
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
