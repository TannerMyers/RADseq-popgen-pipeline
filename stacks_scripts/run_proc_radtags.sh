#!/usr/bin/env bash

# This script runs the Stacks 

# Name Variables
 ## Read variables are command line arguments. Enter your file names when you run script 
 ## with ./run_procradtags.sh *insert command line arguments here*
READ1=$1
READ2=$2 
BARCODES=$3
ENZYME1=$4 
ENZYME2=$5 
OUT_DIR=$6

# Load Modules
module load stacks
    
        process_radtags \
            -1 $READ1 \
            -2 $READ2 \
            -b $BARCODES \
            -o $OUT_DIR \
            --renz_1 $ENZYME1 \
            --renz_2 $ENZYME2 \
            -i gzfastq \
            --rescue \
            --quality \
            --clean \
            --inline_null
