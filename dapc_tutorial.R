### cristatellus pop gen ###

### using adegenet for scripting course project
### uses cristatellus SNP data from Quach et al. (2020)

setwd("~/Documents/Documents - Morgan’s MacBook Air - 1/courses/Scripting-Biologists/cristatellus_pop-gen")

library(adegenet)
packageDescription("adegenet", fields = "Version")
?adegenet

#adegenetTutorial("dapc")  #for documentation

#file "65filteredsinglepoly.fasta" is a fasta file containing SNPs after filtering
# I think this is what I want for analysis
# The same file name but with .str should be identical and also work

#this does not work because it expects diploidy
snps <- read.structure("65filteredsinglepoly.str", n.ind=96, n.loc=3411, col.lab=1, 
                       col.pop=0, row.marknames=0)


dat <- read.table("65filteredsinglepoly.str", head=FALSE)
dat
x <- df2genind(dat, ploidy=1) # conversion to genind
x
truenames(x) # see internal coding
genind2df(x) # check that conversion is OK

#it produces an object but I don't know how to tell if it's okay since I don't
# know what the file object is supposed to look like
#I think it's alright? 
#looking at page 21 of tutorial makes me think it's wrong though
#file:///Users/morgan/Downloads/tutorial-basics.pdf

### Test for Hardy-Weinberg equilibrium
library(pegas)
dat.hw.test <- hw.test(x, B=0)
dat.hw.test #it produces all NAs; this doesn't work


####
#Running the PCA
lizards <- x
sum(is.na(lizards$tab)) #returns 0 for missing data; something is wrong? or, I thought missing data were values of -9

X <- tab(lizards, freq = TRUE, NA.method = "mean") #should replace missing data with tabs

pca1 <- dudi.pca(X, scale = FALSE, scannf = FALSE, nf = 3)
barplot(pca1$eig[1:50], main = "PCA eigenvalues", col = heat.colors(50))

pca1 #well this appears to actually produce something, unknown what it is

#this does not work
s.class(pca1$li,pop(lizards),xax=1,yax=3,sub="PCA 1-3",csub=2)
#Error in s.class(pca1$li, pop(lizards), xax = 1, yax = 3, sub = "PCA 1-3",  : 
#factor expected for fac
title("PCA of cristatellus dataset\naxes 1-3")
add.scatter.eig(pca1$eig[1:20],nf=3,xax=1,yax=3)


#####
### DAPS
#should run on data after transforming with PCA; reduction of dimensions speeds up clustering algorithm
str(x)
data(x) #says dataset x not found?
names(x)

#clustering algorithm will do a PCA first (don't use previous results) and then
# a k-means algorithm
# n.pca() specifies how many number of retained PCAs; decide based on previous results


#find clusters/groups, k-means clustering algorithm will maximize variation among groups
# and minimize within-group variance

grp <- find.clusters(x, max.n.clust=40) #I went with 4 PCAs
#then, choose number of clusters roughly based on the resulting BIC plot
#a little tough to differentiate, but there's a drop at 34? try it?
#13 also looks like the lowest value before it went back up again, or 17
#I think I can know real groups (clusters) by looking at recorded pops in data somewhere?

names(grp)

## Run the DAPC
dapc1 <- dapc(x, grp$grp)
#asks for number of PCs to retain again, don't want to retain too many components
# to avoid overfitting
#based roughly on plot, I'll retain 50 (n.pca() argument)
#next pops up a plot of eigenvalues, and it asks for number of discriminant functions to retain
#retain all eigenvalues for small number of clusters, but if 10s of clusters are analyzed,
# then first few dimensions will have more information than others
#I will keep the first 8, based on the plot (n.da() argument)

dapc1 #look at the resulting object
#?dapc for more info
#ind.coord and grp.coord have coordinates for individuals in plot
#contribution of alleles to discriminant functions in var.contr
#eigenvalues in eig

#Plot the results
scatter(dapc1, posi.da="bottomright", bg="white", pch=17:22)
#I see a couple groups but it's impossible to interpret like this

myCol <- c("darkblue","purple","green","orange","red","blue")
scatter(dapc1, posi.da="bottomright", bg="white",
        pch=17:22, cstar=0, col=myCol, scree.pca=TRUE,
        posi.pca="bottomleft")
#I don't know why the above two don't produce circles but the one below does

scatter(dapc1, scree.da=FALSE, bg="white", pch=20, cell=0, cstar=0, col=myCol, solid=.4,
        cex=3,clab=0, leg=TRUE, txt.leg=paste("Cluster",1:6))

scatter(dapc1, ratio.pca=0.3, bg="white", pch=20, cell=0,
        cstar=0, col=myCol, solid=.4, cex=3, clab=0,
        mstree=TRUE, scree.da=FALSE, posi.pca="bottomright",
        leg=TRUE, txt.leg=paste("Cluster",1:6))
par(xpd=TRUE)
points(dapc1$grp.coord[,1], dapc1$grp.coord[,2], pch=4,
       cex=3, lwd=8, col="black")
points(dapc1$grp.coord[,1], dapc1$grp.coord[,2], pch=4,
       cex=3, lwd=2, col=myCol)
myInset <- function(){
  temp <- dapc1$pca.eig
  temp <- 100* cumsum(temp)/sum(temp)
  plot(temp, col=rep(c("black","lightgrey"),
                     c(dapc1$n.pca,1000)), ylim=c(0,100),
       xlab="PCA axis", ylab="Cumulated variance (%)",
       cex=1, pch=20, type="h", lwd=2)
}
add.scatter(myInset(), posi="bottomright",
            inset=c(-0.03,-0.01),  ratio=.28,
            bg=transp("white"))
#EW
#I think my mistake was retaining too many of something, not sure what yet 
#pick just one or two of these plots for the final version
#I think my mistake was using find.clusters(), should define clusters a priori by number of pops sampled according to paper

## Interpreting variable contributions
# Compute contributions of alleles (loadings are uninformative as they tend to be for PCs)


myPal <- colorRampPalette(c("blue","gold","red"))
scatter(dapc1, col=transp(myPal(6)), scree.da=FALSE,
        cell=1.5, cex=2, bg="white",cstar=0)
#again with the numbers instead of the circles. mayube there just aren't enough dots
# in each group or they're too small so the group labels just cover it up

## Interpreting groups
#clusters of groups can be plotted in many ways, see tutorial




### Go through paper later and see what parameters they chose to see if I replicated results
# https://academic.oup.com/biolinnean/article/129/1/114/5612548?login=true 

