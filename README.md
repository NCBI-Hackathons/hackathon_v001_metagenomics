NCBI January, 2015 Hackathon - Metagenomics 
=============

Overview - Metagenomics pipeline for NCBI Hackathon
--------

The following are a number of pipelines for viral discovery in whole (meta)genomic shotgun sequencing.

Description of the hackathon:

> We assembled groups of genomics professionals to assess whether we could rapidly assemble pipelines to answer biological
> questions commonly asked by biologists and others new to bioinformatics. In January 2015, groups were assembled on the
> National Institutes of Health (NIH) campus to address questions in the DNA-seq, Epigenomics, Metagenomics and RNA-seq
> subfields of genomics. The only two rules set for this hackathon were that data either had to include those housed at the
> National Center for Biotechnology Information (NCBI) or from the participants (as long as they would be submitted to NCBI
> within six months of the hackathon), and that all software going into the pipeline had to be open-source or open-use. 
> Proposed questions, as well as suggested tools and approaches, were distributed to participants a few days before the event
> and were refined during the event.  Pipelines were published on Github, a web service providing publicly available, free-usage
> tiers for collaborative software development (https://github.com/features/). 
> The code was published at https://github.com/DCGenomics/ with separate repositories for each team. 

For more information on the goals of the hackathon, see:

PlosONE paper

Data Sources
------------
To be filled in

Pipeline descriptions
------------
To be filled in

Running the pipelines locally
----------------

NCBI's [sratoolkit](http://www.ncbi.nlm.nih.gov/Traces/sra/?view=software)
```
wget http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.4.3/sratoolkit.2.4.3-ubuntu64.tar.gz
tar xfz sratoolkit.2.4.3-ubuntu64.tar.gz
export PATH=$PATH:$PWD/sratoolkit.2.4.3-ubuntu64/bin
vdb-config -i
```
‘latf-load’ , ‘blastn_vdb’, ‘fastq-dump’, ‘prefetch’, ‘vdb-config’, ‘align-info’, and ‘kar’ should now be in your path 

NCBI's [refseq](http://www.ncbi.nlm.nih.gov/refseq/)
```
wget ftp://ftp.ncbi.nlm.nih.gov/refseq/release/viral/*.fna*
gunzip *.fna*
```
[Human Microbiome Project](hmpdacc.org)'s test examples
```
wget ftp://public-ftp.hmpdacc.org/Illumina/right_retroauricular_crease/*
tar jxf * # warning - will take a long time. there are example datasets in this repo
```

Downloading the current pipelines
```
git clone https://github.com/DCGenomics/hackathon_v001_metagenomics.git
export PATH=$PATH:/bin/hackathon_v001_metagenomics/sra_blast/bin/
export PATH=$PATH:/bin/hackathon_v001_metagenomics/contig_blast/
```
Testing on two samples
```
sra_blast.sh -v /path/viral_refence.faa SRR00000 SRR00001
summarize_samples.R SRR00000.blast.results SRR00001.blast.results
```
