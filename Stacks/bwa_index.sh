#!/usr/bin/env bash

# Load bwa module
module load bwa/0.7.17  

# Download genome from Ensembl FTP site beforehand 
genome_fa=$1

# Provide directory for indexed genome and the prefix for the output files
index_db=$2

# Create index for reference genome
bwa index -p $index_db $genome_fa
