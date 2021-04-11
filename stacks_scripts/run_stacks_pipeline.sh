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
    # -f is the input file path
    # --name the sample's name
    # -o output file directory
    # -M maximum distance in nucleotides allowed between stacks
    # -m minimum depth of coverage required to create a stack
    # -N maximum distance allowed to align secondary reads to primary stacks 
        ## In my case, I used the same value for m and N 
    # --disable-gapped do not perform gapped alignments between stacks
    # -p allows parallel execution with the number of threads allotted
   ustacks -f $SAMPLE_DIR/${sample}.1.fq.gz -i $id --name $sample -o $OUT_DIR -M $M -m $n -N $n --disable-gapped -p 8
   let "id+=1"
done

# Run cstacks
    ## cstacks builds the catalog of loci
        # -M population map
        # -P path to the file containing stacks output files
        # -n number of mismatches allowed between samples when building the catalog
cstacks -P $OUT_DIR \
   -M $POP_MAP \
   -n $n \
   -p 8    

# Run sstacks
    ## 
sstacks -P $OUT_DIR \
   -M $POP_MAP \
   -p 8 

# Run tsv2bam
    ## 
tsv2bam -P $OUT_DIR \
        -M $POP_MAP \
       --pe-reads-dir $SAMPLE_DIR \
        -t 8 
# Run gstacks
    ## 
gstacks -P $OUT_DIR \
   -M $POP_MAP \
        -t 8 

#################################################################
#    Note: Next two steps are not not necessary unless you have #
#  a reference genome to align your assembled loci to.          # 
#  Skip to populations if you do not have a reference genome.    #          
#################################################################

# Align the consensus catalog loci to a reference genome
bwa mem -t 8 $BWA_DB $OUT_DIR/catalog.fa.gz |
    samtools view -b |
    samtools sort --threads 4 > $OUT_DIR/aligned_catalog.bam

# Run stacks-integrate-alignments
    ## Integrate reference genome alignment information into catalog loci
stacks-integrate-alignments -P $OUT_DIR \
    -B $OUT_DIR/aligned_catalog.bam \
    -O $OUT_DIR/integrated-alignment

# Run populations
    # -R sets the minimum percentage of individuals across populations required to process a locus
    # -r sets the minimum percentage of individuals within a population required to process a locus for that population.
        ## Use `-p` to set a minimum number of populations that must be present for a locus to be processed.
    # --write-single-snp restricts the number of polymorphic sites to include only the first SNP on a locus for analysis
    # --min-mac sets the minimum minor allele count. Use `2` to exclude singletons
    # --hwe estimates divergence from Hardy-Weiberg equilibrium for each locus
    # --fstats estimates F statistics for each SNP
    # The --vcf through --plink flags specify file formats for downstream analysis
    # software. Include more or less depending on the goals you have for your dataset.
    # More can be found by typing `populations --help` on the command line.
populations -P $OUT_DIR \
    -M $POP_MAP \ 
    -t 8 \
    -R 0.5 \
    -r 0.5 \
    --min-mac 2 \
    --write-single-snp \
    --hwe \
    --fstats \
    --vcf
    --fasta-samples \
    --fasta-loci \
    --structure \
    --phylip-var \
    --plink  