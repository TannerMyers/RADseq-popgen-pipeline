###################################################################
# This script plots Q estimates obtained from Admixture in a bar- #
# plot i.e., the classic structure plot.			  #
###################################################################

# Change to your working directory
setwd("/scratch/tcm0036/scripting-project/RADseq-popgen-pipeline/Admixture")

# Load library `stringr` for regex 
# install.packages("stringr") # run once
library(stringr)

# Iterate over the different .Q extension files produced by Admixture to generate
# barplots showing ancestry
files <- list.files(pattern=".Q")
for (Q in files){
    output <- basename(file.path(Q, fsep=".Q"))
    
    K <- str_extract(Q, '(\\.[0-9]+\\.)')
    K <- str_extract(K,'[0-9]+') # there is a better way to do this with only 1 line of code, but this works for now

    # Read in the .Q file as a table
    tbl <- read.table(Q, header=FALSE, fill=TRUE)

    # Save plots as pdfs
    pdf(file = paste0("Admixture_",Q,".pdf"))
    
    # Make structure plot using rainbow colors for different K values
    barplot(t(as.matrix(tbl)), col=rainbow(K), 
	main=paste0("K =",K),
    	xlab="Individual #", ylab="Ancestry", border=NA)
    dev.off()
}
