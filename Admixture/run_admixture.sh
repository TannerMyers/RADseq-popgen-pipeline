#!/usr/bin/env bash

# Before running, initialize your conda environment with `Admixture`
#conda init bash
#conda activate admixture

# Name variables
INPUT_FILE=$1

# Run Admixture on a number of "K" value.
for K in 1 2 3 4 5 6 7 8 9 10; 
	do
	    # Run admixture with cross validation
	    admixture --cv $INPUT_FILE $K | tee log${K}.out

	done

# Run R plotting script to visualize Q estimates.
Rscript plot_Admixture.r
