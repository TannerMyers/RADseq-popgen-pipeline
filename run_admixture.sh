#!/usr/bin/env bash

# Name variables
INPUT_FILE=$1

# Run Admixture on a number of "K" value.
for K in 1 2 3 4 5 6 7 8 9 10; 
	do
	    admixture -B20 --cv $INPUT_FILE $K -j4

	done
