#!/usr/bin/env bash

# This script runs the entire Stacks pipeline from ustacks through populations #

# Assign variables

## Set command line arguments for M and n -- the number of mismatches allowed 
## between stacks within individuals and mismatches allowed between stacks
## between individuals
#M=$1
#n=$2 
#POP_MAP=$3    ### are the commented out pop_map and out_dir lines necessary or can they be removed?
#OUT_DIR=$4
POP_MAP=$1
OUT_DIR=$2

#SAMPLE_DIR=/scratch/phyletica/distichus/samples   ###can this be removed

#SAMPLES=`awk 'BEGIN {OFS = FS} {print $1}' $POP_MAP`   ###can this be removed

### [add in description of what this variable is]

BWA_DB=/scratch/phyletica/distichus/genome/bwa/anocar

# Load necessary modules 
module load stacks
module load python
module load samtools
module load bwa

#id=1
#for sample in $SAMPLES 
#do
#   ustacks -f $SAMPLE_DIR/${sample}.1.fq.gz -i $id --name $sample -o $OUT_DIR -M $M -m $n -N $n --disable-gapped -p 8
#   let "id+=1"
#done

#cstacks -P $OUT_DIR \
#   -M $POP_MAP \
#   -n $n \
#   -p 8    

#sstacks -P $OUT_DIR \
#   -M $POP_MAP \
#   -p 8 

#tsv2bam -P $OUT_DIR \
#        -M $POP_MAP \
#       --pe-reads-dir $SAMPLE_DIR \
#        -t 8 

#gstacks -P $OUT_DIR \
#   -M $POP_MAP \
#        -t 8 

#bwa mem -t 8 $BWA_DB $OUT_DIR/catalog.fa.gz |
#    samtools view -b |
#    samtools sort --threads 4 > $OUT_DIR/aligned_catalog.bam

# Confused about what "stacks_dir" refers to with the "-P" flag
#stacks-integrate-alignments -P $OUT_DIR \
#    -B $OUT_DIR/aligned_catalog.bam \
#    -O $OUT_DIR/integrated-alignment

populations -P $OUT_DIR -M $POP_MAP -t 8 --vcf 
#       -R 0.65 \
#       --min-mac 2 \
#       --write-single-snp \
#       --fasta-samples \
#       --fasta-loci \
#   --structure \
#   --hwe \
#   --fstats \
#   --phylip-var \
#   --plink  




### It looks like the current blocks below the modules loads are for different analyses. Could you add a comment before each one explaining what that block does? Also, will this mean that the script is modified for different things, or are all the things currently commented out actually run every time you run the script?
### It could be useful to add an if statement at the very beginning that double checks that the user has specified all the necessary files and spits out an error message if they haven't
