#!/bin/bash

# Grab the viral 
mkdir refseq_viral
mkdir HMP
mkdir HMP/illumina
mkdir HMP/illumina/right_retroauricular_crease
mkdir HMP/scaffolds
mkdir HMP/scaffolds/right_retroauricular_crease

cd refseq_viral
wget ftp://ftp.ncbi.nlm.nih.gov/refseq/release/viral/*
cd ..

cd HMP
cd illumina/right_retroauricular_crease
wget ftp://public-ftp.hmpdacc.org/Illumina/right_retroauricular_crease/*
cd ..

cd scaffolds/right_retroauricular_crease
wget ftp://public-ftp.hmpdacc.org/HMASM/PGAs/right_retroauricular_crease/*