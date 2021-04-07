#!/usr/bin/env bash


# Name variables
INPUT_FILE=$1

OUTPUT_DIR=$2

# This array will be used as K values for Admixture runs
POPULATIONS=(1 2 3 4 5 6 7 8 9 10)

# Run Admixture on a number of "K" value.
for K in ${POPULATIONS[@]}; 
	do
	    admixture $INPUT_FILE $K
	done
