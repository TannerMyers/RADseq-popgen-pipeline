
### INSTALL NECESSARY PACKAGES AND SET WORKING DIRECTORY

#install.packages("conStruct")
#install.packages("vcfR")
library(conStruct)
library(ps, lib.loc = "/Library/Frameworks/R.framework/Versions/3.6/Resources/library")
library(conStruct, lib.loc = "/Library/Frameworks/R.framework/Versions/3.6/Resources/library")
library(rasterVis)
library(raster)
library(rgl)
library(rgdal)
library(elevatr)
library(topoDistance)


#Use this to load data included in packages for vignettes
#data(conStruct.data)

setwd("/Users/claire/Desktop/Scripting/project/")
#setwd("/Users/claire/Desktop/Scripting/RADseq-popgen-pipeline/conStruct/")

##############################################
############ NOTES FROM VIGNETTES ############ 
##############################################

## Formatting Data ##
vignette(topic="format-data",package="conStruct")


#look at allele frequency data
conStruct.data$allele.frequencies[1:5,1:10]

#look at lat/long data
conStruct.data$coords[1:5,]

#look at geodist data
#this is necessary if running the spatial model in conStruct
conStruct.data$geoDist[1:5,1:5]

#convert from STRUCTURE to format used in conStruct
conStruct.data <- structure2conStruct(infile = "~/Desktop/myStructureData.str",
                                     onerowperind = TRUE,
                                     start.loci = 3,
                                     start.samples = 1,
                                     missing.datum = -9,
                                     outfile = "~/Desktop/myConStructData")

## How to Run an Analysis ##

# default model is spatial model

# run a conStruct analysis

#   you have to specify:
#       the number of layers (K)
#       the allele frequency data (freqs)
#       the geographic distance matrix (geoDist)
#       the sampling coordinates (coords)

#my.run <- conStruct(spatial = TRUE, 
#                    K = 3, 
#                    freqs = conStruct.data$allele.frequencies,
#                    geoDist = conStruct.data$geoDist, 
#                    coords = conStruct.data$coords,
#                    prefix = "spK3")


# run a non-spatial conStruct analysis

#   you have to specify:
#       the number of layers (K)
#       the allele frequency data (freqs)
#       the sampling coordinates (coords)

#my.run <- conStruct(spatial = FALSE, 
#                    K = 2, 
#                    freqs = conStruct.data$allele.frequencies, 
#                    geoDist = NULL, 
#                    coords = conStruct.data$coords,
#                    prefix = "nspK2")

#all possible options for call, values below are default values but can be altered

#my.run <- conStruct(spatial = TRUE, 
#                    K = 3, 
#                    freqs = conStruct.data$allele.frequencies, 
#                    geoDist = conStruct.data$geoDist, 
#                    coords = conStruct.data$coords, 
#                    prefix = "spK3", 
#                    n.chains = 1, 
#                    n.iter = 1000, 
#                    make.figs = TRUE, 
#                    save.files = TRUE)

vignette(topic="run-conStruct",package="conStruct")
vignette(topic="visualize-results",package="conStruct")
vignette(topic="model-comparison",package="conStruct")
data(conStruct.data)
# to run a cross-validation analysis
# you have to specify:
#       the numbers of layers you want to compare (K)
#       the allele frequency data (freqs)
#       the geographic distance matrix (geoDist)
#       the sampling coordinates (coords)

my.xvals <- x.validation(train.prop = 0.9,
                         n.reps = 8,
                         K = 1:3,
                         freqs = conStruct.data$allele.frequencies,
                         data.partitions = NULL,
                         geoDist = conStruct.data$geoDist,
                         coords = conStruct.data$coords,
                         prefix = "example",
                         n.iter = 1e3,
                         make.figs = TRUE,
                         save.files = FALSE,
                         parallel = FALSE,
                         n.nodes = NULL)# to run a cross-validation analysis
# you have to specify:
#       the numbers of layers you want to compare (K)
#       the allele frequency data (freqs)
#       the geographic distance matrix (geoDist)
#       the sampling coordinates (coords)

my.xvals <- x.validation(train.prop = 0.9,
                         n.reps = 8,
                         K = 1:3,
                         freqs = conStruct.data$allele.frequencies,
                         data.partitions = NULL,
                         geoDist = conStruct.data$geoDist,
                         coords = conStruct.data$coords,
                         prefix = "example",
                         n.iter = 1e3,
                         make.figs = TRUE,
                         save.files = FALSE,
                         parallel = FALSE,
                         n.nodes = NULL)


##############################################
############# SCRIPTING PROJECT ############## 
##############################################


#vcf_data <- read.vcfR("Mikles_et_al._SongSparrows_MolecularEcology2020.vcf")
#convert vcf to structure format in pgdspider

mydata <- structure2conStruct(infile = "~/Desktop/Scripting/project/Mickles_data3_reduced2.str",
                                        onerowperind = FALSE,
                                        start.loci = 3,
                                        start.samples = 2,
                                        missing.datum = -9,
                                        outfile = "~/Desktop/Scripting/project/Mickles_construct_reduced2")


localities <- read.csv("Mickles_latlong_reduced2.csv")

#localities <- localities[,2:3]

#Getting DEM file for USA 
raster::getData('alt', country='USA', mask=TRUE)
DEM <- raster("USA1_msk_alt.grd")


#extracting min and max values to use for the DEM file
min.lat <- floor(min(localities$Lat))
max.lat <- ceiling(max(localities$Lat))
max.lon <- ceiling(max(localities$Long))
min.lon <- floor(min(localities$Long))

#setting geographic extent to crop the DEM file
geog.extent <- extent(x = c(min.lon, max.lon, min.lat, max.lat))
#cropping the dem file so it's not as large
DEM_crop <- crop(x=DEM, y=geog.extent)

#Changing order of localities file, need long first, then lat
xy <- matrix(ncol=2, c(localities$Long, localities$Lat))

#removing a few entries which when run in the topodistance command created INF values
xy_reduced <- xy[c(1:11, 22:138, 140:147), ]

#getting error that some coordinates not found and omitted when using the cropped DEM, trying the whole DEM
#this was fixed by putting longitude first, then latitude in the pts file 
tdist <- topoDist(DEM_crop$USA1_msk_alt,  
                  pts = xy_reduced, paths=FALSE) 

write.csv(tdist, file="topographicDistance.csv")
help(write.csv)
## running analyses

# Starting out with non-spatial run
my.run <- conStruct(spatial = FALSE, 
                    K = 4, 
                    freqs = mydata, 
                    geoDist = NULL, 
                    coords = coords,
                    prefix = "nspK4")

## Visualization

#Load Results
load("nspK3_conStruct.results.Robj")
admix.props <- conStruct.results$chain_1$MAP$admix.proportions

make.structure.plot(admix.proportions = admix.props, + mar = c(4.5,4,2,2), sort.by = 1)

# make the desired map
maps::map(xlim = range(xy_reduced[,1]) + c(-5,5), ylim = range(xy_reduced[,2])+c(-2,2), col="gray")
# add the admixture pie plot
make.admix.pie.plot(admix.proportions = admix.props,
                    coords = localities,
                    add = TRUE)


#Now doing a spatial run

my.run <- conStruct(spatial = TRUE, 
                    K = 3, 
                    freqs = mydata, 
                    geoDist = tdist, 
                    n.iter = 500,
                    coords = xy_reduced,
                    prefix = "nspK3")

#Load Results
load("nspK3_conStruct.results.Robj")
admix.props <- conStruct.results$chain_1$MAP$admix.proportions
#make.structure.plot(admix.proportions = admix.props)

#Make a map and add the pie results on top
maps::map(xlim = range(xy_reduced[,1]) + c(-2,2), ylim = range(xy_reduced[,2])+c(-5,5), col="black", database="state")
maps::map('state', 'california')
make.admix.pie.plot(admix.proportions = admix.props,
                    coords = xy_reduced,
                    radii = 1.5,
                    add = TRUE)
make.structure.plot(admix.proportions = admix.props, sort.by = 1,
                    layer.order = c(1,2,3),
                    sample.names = localities$Sample.ID,
                    mar = c(4.5,4,2,2))
#sort by latitude
#make.structure.plot(admix.proportions = admix.props,
#                   sample.order = order(data.block$coords[,1]))


######COMPARE TWO RUNS##########

# load output files from a run with 
#   the non-spatial model and K=3
load("nspK3_conStruct.results.Robj")
load("nspK3_data.block.Robj")

# assign to new variable names
spK3_cr <- conStruct.results
spK3_db <- data.block

# load output files from a run with 
#   the spatial model and K=3
load("nspK2_conStruct.results.Robj")
load("nspK2_data.block.Robj")

# assign to new variable names
spK2_cr <- conStruct.results
spK2_db <- data.block

# compare the two runs with different K values
compare.two.runs(conStruct.results1=spK2_cr,
                 data.block1=spK2_db,
                 conStruct.results2=spK3_cr,
                 data.block2=spK3_db,
                 prefix="nspK2_vs_spK3")







####

my.xvals <- x.validation(train.prop = 0.9,
                         n.reps = 2,
                         K = 1:3,
                         freqs = conStruct.data$allele.frequencies,
                         data.partitions = NULL,
                         geoDist = conStruct.data$geoDist,
                         coords = conStruct.data$coords,
                         prefix = "test1",
                         n.iter = 500,
                         make.figs = TRUE,
                         save.files = FALSE,
                         parallel = FALSE,
                         n.nodes = NULL)
sp.results <- as.matrix(
  read.table("test1_sp_xval_results.txt",
             header = TRUE,
             stringsAsFactors = FALSE)
)
nsp.results <- as.matrix(
  read.table("test1_nsp_xval_results.txt",
             header = TRUE,
             stringsAsFactors = FALSE)
)
sp.results <- Reduce("cbind",lapply(my.xvals,function(x){unlist(x$sp)}),init=NULL)
nsp.results <- Reduce("cbind",lapply(my.xvals,function(x){unlist(x$nsp)}),init=NULL)

#get 95% CIs
sp.CIs <- apply(sp.results,1,function(x){mean(x) + c(-1.96,1.96) * sd(x)/length(x)})
nsp.CIs <- apply(nsp.results,1,function(x){mean(x) + c(-1.96,1.96) * sd(x)/length(x)})


# then, plot cross-validation results for K=1:3 with 2 replicates
par(mfrow=c(1,2))
plot(rowMeans(sp.results),
     pch=19,col="blue",
     ylab="predictive accuracy",xlab="values of K",
     ylim=range(sp.results,nsp.results),
     main="cross-validation results")
points(rowMeans(nsp.results),col="green",pch=19)


#do a test between spatial and non-spatial to see if significantly different
t.test(sp.results[3,],nsp.results[3,],paired=TRUE,alternative="greater")
