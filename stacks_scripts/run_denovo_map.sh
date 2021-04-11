#!/usr/bin/env bash 

M=$1

n=$2

# Name --popmap variable
POP_MAP=/scratch/phyletica/distichus/info/popmap.tsv

# Name --samples variable
SAMPLES=/scratch/phyletica/distichus/samples 
		
# Name variable for output files --> to 'stacks.denovo'
OUT_DIR=/scratch/phyletica/distichus/stacks.denovo/uncleaned/

# Move into directory for output files
cd $OUT_DIR
				
	module load stacks

	denovo_map.pl \
		-M $M \
		-n $n \
		--out-path $OUT_DIR \
		--popmap $POP_MAP \
		--samples $SAMPLES \
		--paired \
		-X "populations: --out-path $OUT_DIR --vcf"				

