#!/usr/bin/env bash

# This script runs process_radtags to demultiplex RADseq data

# Name Variables
 ## Variables are entered as command line arguments. Enter your file names when you run script 
 ## with ./run_procradtags.sh *insert command line arguments here*
READ1=$1
READ2=$2 
BARCODES=$3
ENZYME1=$4 
ENZYME2=$5 
OUT_DIR=$6

# Load modules
module load stacks

# process_radtags has many options that vary depending on the RADseq 
# protocol you used and whether the sequencer did any demultiplexing of
# data. I would recommend referring to the Stacks manual (http://catchenlab.life.illinois.edu/stacks/manual/)
# for reference, but I will explain the significance of each flag here.
    ## -1 and -2 signify the single and paired ends respectively
    ## -b signifies the barcodes file – a tab-delimited file containing your barcodes and sample IDs 
    ## -o refers to the directory you want the demultiplexed fastq files to be written to
    ## -i refers to the type of input file; in my case, they were gzipped fastq files
    ## --renz_1 signifies the first restriction enzyme
    ## --renz_2 signifies the second restriction enzyme; if you are using a single digest protocol, use -e/--enz to specify your enzyme
    ## --rescue, --quality, and --clean are quality controls that drop uncalled bases, filter out those of low-quality, and rescue barcodes and RADtags 
    ## --inline_null tells process_radtags where the barcodes are located in the fastq file. There are many other options that can be used and
    ## you will need to look at your data (zcat *.fq.gz | head) to identify which flag is appropriate 
    process_radtags \
        -1 $READ1 \
        -2 $READ2 \
        -b $BARCODES \
        -o $OUT_DIR \
        -i gzfastq \
        --renz_1 $ENZYME1 \
        --renz_2 $ENZYME2 \
        --rescue \
        --quality \
        --clean \
        --inline_null
