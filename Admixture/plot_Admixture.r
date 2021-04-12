###################################################################
# This script plots Q estimates obtained from Admixture in a bar- #
# plot i.e., the classic structure plot.			  #
###################################################################

# Change to your working directory
setwd("/scratch/tcm0036/scripting-project/RADseq-popgen-pipeline/Admixture-test")



tbl=read.table("populations_r20.haplotypes.filtered_m70_randomSNP_recoded.4.Q")
# Save plots as pdf format 
pdf(file="")
barplot(t(as.matrix(tbl)), col=rainbow(3),
xlab="Individual #", ylab="Ancestry", border=NA)
dev.off()
>>>>>>> e9e4c128afcd11ab3e87a58e96a4970ce8b1c0c7
