#! /bin/bash

### Bash and awk code shared by Pietro de Mello					### 
### This script summarizes the output of the stacks function `process_radtags`, ###
### which divides raw fastq files into individual fastq files for each sample	###

# Set working directory
work_dir=/scratch/phyletica/distichus

# Print out standard output & standard error output by process_radtags
for out_error in $work_dir/cleaned/cleaned*_*/*.oe; 
	do
		basename $(echo $out_error)
		tail -n5 $out_error
		echo
	done

for out_error in $work_dir/cleaned/cleaned*_*/*log ; 
	do
	basename $(echo $out_error)
	awk 'p;/NoRadTag/{p=1}/^ *$/{p=0}' $out_error | sort -k6 -n | \
		awk 'BEGIN {c = 0; sum = 0;} $6 ~ /^(\-)?[0-9]*(\.[0-9]*)?$/ {a[c++] = $6;sum += $6;} \
			END { ave = sum / c; if( (c % 2) == 1 ) { median = a[ int(c/2) ];} else {median = ( a[c/2] + a[c/2-1] ) / 2;} \
			OFS="\t"; print "# of samples " c, "| average " ave, "| median " median, "| smallest " a[1], "| largest " a[c-1];}'
		echo  
	done

for out_error in $work_dir/cleaned/cleaned*_*/*log ; 
	do
		awk 'p;/NoRadTag/{p=1}/^ *$/{p=0}' $out_error | awk 'BEGIN {FS = OFS = "\t"} {print $2,$6} \'
	done | \
		sort -k1 | awk 'OFS="\t" {print}' | tail -n288 > $work_dir/cleaned/reads_per_sample.tsv 	 

# Tail is temporary solution for getting rid of white space at beginning of file because regex in Pietro's code yields an empty file
