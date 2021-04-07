### cristatellus pop gen ###

### using adegenet for scripting course project
### uses cristatellus SNP data from Quach et al. (2020)

# Works best in Rstudio - some components of dapc are interactive

setwd("~/Documents/Documents - Morgan’s MacBook Air - 1/courses/Scripting-Biologists/cristatellus_pop-gen")

library(adegenet)
packageDescription("adegenet", fields = "Version")
?adegenet

#adegenetTutorial("dapc")  #for documentation

#file "65filteredsinglepoly.fasta" is a fasta file containing SNPs after filtering
#corresponding structure file by the same name has same info - will use for analysis

#Import SNP data, via structure file
dat <- read.table("65filteredsinglepoly.str", head=FALSE)
dat
#convert to haploid genind object
lizards <- df2genind(dat, ploidy=1) # conversion to genind
lizards

#####
### DAPS

#clustering algorithm will do a PCA first

#find clusters/groups, k-means clustering algorithm will maximize variation among groups
# and minimize within-group variance
grp <- find.clusters(lizards, max.n.clust=4)
# plots BIC, lower is better but use "elbow rule" to determine good number
#I chose k=2 based on replicating the paper's choices/decisions
###Note - other methods for choosing clusters outside this package may be
### better, and identifying good # of clusters for empirical data is tricky business

#retained 200 PCs, choose 2 for # of clusters


## Run the DAPC
dapc1 <- dapc(lizards, grp$grp)
#retained 45 PCAs, 2 linear discriminants (based on plots)
#asks for number of PCs to retain again, don't want to retain too many components
# to avoid overfitting

#next pops up a plot of eigenvalues, and it asks for number of discriminant functions to retain
#retain all eigenvalues for small number of clusters, but if 10s of clusters are analyzed,
# then first few dimensions will have more information than others

dapc1 #look at the resulting object
#?dapc for more info
#ind.coord and grp.coord have coordinates for individuals in plot
#contribution of alleles to discriminant functions in var.contr
#eigenvalues in eig

dapc1$assign #shows which group each sample (in order) is assigned to which group

## Plot the results
scatter(dapc1, posi.da="bottomright", bg="white", pch=17:22)
#Results clearly show two clusters, and plot density

#overall these results show that lizards from two different islands form
# separate clusters

# More analyses will let you see contributions of individual loci to groupings

