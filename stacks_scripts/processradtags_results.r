## This script plots results and estimate summary statistics
## of RADseq reads demultiplexing and cleaning through stacks' 
## `process_radtags` function

# Prior to running, use one-liner found in README

# Add your working directory here
setwd("")

samplereads <- read.table("reads_per_sample.tsv", sep = "\t",
                          header = FALSE)

samplereads <- samplereads[order(samplereads$V2),] # sort from fewest to most reads
colnames(samplereads) <- c("Specimen", "Retained_Reads")


# plot data
plot(samplereads$Retained_Reads, ylab = "Number of Retained Reads", 
    xlab = "Sample")

# plot the 50 samples with the fewest reads*
plot(samplereads$Retained_Reads[1:50])

# plot the 16 samples with the fewest reads*
plot(samplereads$Specimen[1:16], samplereads$Retained_Reads[1:16]) # 16 samples have fewer than 500K reads

head(samplereads,n=16)

#* Change numbers based on your dataset. In my case, there were 16 samples with noticeably fewer reads than the rest