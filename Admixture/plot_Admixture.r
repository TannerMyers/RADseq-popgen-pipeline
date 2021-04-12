###################################################################
# This script plots Q estimates obtained from Admixture in a bar- #
# plot i.e., the classic structure plot.			  #
###################################################################

# Change to your working directory
setwd("/scratch/tcm0036/scripting-project/RADseq-popgen-pipeline/Admixture-test")

# Iterate over the different .Q extension files produced by Admixture to generate
# barplots showing ancestry
files <- list.files(pattern=".Q")
for (Q in files){
    output <- basename(file.path(Q, fsep=".Q"))
    
    # Read in the .Q file as a table
    tbl <- read.table(Q)

    # Save plots as pdfs
    pdf(file = paste0("Admixture_",Q,".pdf"))
    
    # Make structure plot using rainbow colors for different K values
    barplot(t(as.matrix(tbl)), col=rainbow(),
    xlab="Individual #", ylab="Ancestry", border=NA)
    dev.off()
}

#tbl=read.table("populations_r20.haplotypes.filtered_m70_randomSNP_recoded.4.Q")
# Save plots as pdf format 
#pdf(file="")
#barplot(t(as.matrix(tbl)), col=rainbow(3),
#xlab="Individual #", ylab="Ancestry", border=NA)
#dev.off()
