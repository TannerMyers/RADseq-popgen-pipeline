## This script plots results and estimate summary statistics
## of RADseq reads demultiplexing and cleaning through stacks' 
## `process_radtags` function

setwd("~/Dropbox/Distichus_Project/ddRADseq_Phylogeography/stacks/")

samplereads <- read.table("process_radtags/reads_per_sample.tsv", sep = "\t",
                          header = FALSE)

samplereads <- samplereads[order(samplereads$V2),] # sort from fewest to most reads
colnames(samplereads) <- c("Specimen", "Retained_Reads")


# plot data
plot(samplereads$Retained_Reads, ylab = "Number of Retained Reads", 
    xlab = "Sample")

# plot the 50 samples with the fewest reads
plot(samplereads$Retained_Reads[1:50])

# plot the 16 samples with the fewest reads
plot(samplereads$Specimen[1:16], samplereads$Retained_Reads[1:16]) # 16 samples have fewer than 500K reads

head(samplereads,n=16)
# Sample  Reads Taxon   Locality
# 4404  22062 ravitergum 420
# 6081  36108 dom4  543
# 266166  63071 altavelensis
# 266167  63627 altavelensis
# 266168  73058 altavelensis
# 866  82793 ignigularis 82
# 6072 131450 dom4  543
# 4403 174099 ravitergum 420
# 6388 185979 ignigularis 566
# 6780 220379 ignigularis 366
# 617 301474 dom3 22
# 867 301966 ignigularis 82
# 6685 331930 ignigularis 366
# 4391 333240 brevirostris 419
# 6343 363959 ignigularis 380

