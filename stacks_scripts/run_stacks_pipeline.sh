#!/usr/bin/env bash

# This script runs the entire Stacks pipeline from ustacks through populations #

# Assign variables
    ## Set command line arguments for M and n -- the number of mismatches allowed 
    ## between stacks within individuals and mismatches allowed between stacks
    ## between individuals -- as well as for the population map, the directory with
    ## individual level fastq files from process_radtags, and the directory to output files.
M=$1
n=$2 
POP_MAP=$3
SAMPLE_DIR=$4 
OUT_DIR=$5   
    ## If you are using a reference genome, identify the directory containing the indexed reference
    ## genome files from bwa.
BWA_DB=$6   

# Load necessary modules 
module load stacks
module load python # Make sure the module is python3
module load samtools
module load bwa

# Run ustacks
    ## ustacks is the step of the Stacks pipeline that assembles loci within individuals. Each individual
    ## can be treated as its own job so this step can be parallelized.

## Extract the sample IDs from the population map to iterate over with ustacks.
SAMPLES=`awk 'BEGIN {OFS = FS} {print $1}' $POP_MAP`

id=1
for sample in $SAMPLES 
do
   ## ustacks flag definitions:
    # -f
    # --name
    # -o 
    # -M 
    # -m
    # -n 
        ## In my case, I used the same value for m and N 
    # --disable-gapped 
    # -p 
   ustacks -f $SAMPLE_DIR/${sample}.1.fq.gz -i $id --name $sample -o $OUT_DIR -M $M -m $n -N $n --disable-gapped -p 8
   let "id+=1"
done

# Run cstacks
    ## cstacks 
        # n 
cstacks -P $OUT_DIR \
   -M $POP_MAP \
   -n $n \
   -p 8    

sstacks -P $OUT_DIR \
   -M $POP_MAP \
   -p 8 

tsv2bam -P $OUT_DIR \
        -M $POP_MAP \
       --pe-reads-dir $SAMPLE_DIR \
        -t 8 

gstacks -P $OUT_DIR \
   -M $POP_MAP \
        -t 8 

bwa mem -t 8 $BWA_DB $OUT_DIR/catalog.fa.gz |
    samtools view -b |
    samtools sort --threads 4 > $OUT_DIR/aligned_catalog.bam

stacks-integrate-alignments -P $OUT_DIR \
    -B $OUT_DIR/aligned_catalog.bam \
    -O $OUT_DIR/integrated-alignment

# Run populations
    # 
populations -P $OUT_DIR \
    -M $POP_MAP \ 
    -t 8 \
    -R 0.65 \
    --min-mac 2 \
    --write-single-snp \
    --vcf
    --fasta-samples \
    --fasta-loci \
    --structure \
    --hwe \
    --fstats \
    --phylip-var \
    --plink  




### It looks like the current blocks below the modules loads are for different analyses. Could you add a comment before each one explaining what that block does? Also, will this mean that the script is modified for different things, or are all the things currently commented out actually run every time you run the script?
### It could be useful to add an if statement at the very beginning that double checks that the user has specified all the necessary files and spits out an error message if they haven't
