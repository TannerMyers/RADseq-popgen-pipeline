#!/usr/bin/env bash 

# Set values for M and n
M=$1
n=$2

# Name --popmap variable
POP_MAP=$3

# Name --samples variable
SAMPLES=$4
		
# Name variable for output files 
OUT_DIR=$5

# Move into directory for output files
cd $OUT_DIR
				
	module load stacks
	
	# Add other population flags as needed
	denovo_map.pl \
		-M $M \
		-n $n \
		--out-path $OUT_DIR \
		--popmap $POP_MAP \
		--samples $SAMPLES \
		--paired \
		-X "populations: --out-path $OUT_DIR --vcf"		

