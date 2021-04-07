#install.packages("conStruct")
#install.packages("vcfR")
library(conStruct)
data(conStruct.data)

setwd("/Users/claire/Desktop/Scripting/project/")

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

my.run <- conStruct(spatial = TRUE, 
                    K = 3, 
                    freqs = conStruct.data$allele.frequencies,
                    geoDist = conStruct.data$geoDist, 
                    coords = conStruct.data$coords,
                    prefix = "spK3")

# run a non-spatial conStruct analysis

#   you have to specify:
#       the number of layers (K)
#       the allele frequency data (freqs)
#       the sampling coordinates (coords)

my.run <- conStruct(spatial = FALSE, 
                    K = 2, 
                    freqs = conStruct.data$allele.frequencies, 
                    geoDist = NULL, 
                    coords = conStruct.data$coords,
                    prefix = "nspK2")
#all possible options for call, values below are default values but can be altered
my.run <- conStruct(spatial = TRUE, 
                    K = 3, 
                    freqs = conStruct.data$allele.frequencies, 
                    geoDist = conStruct.data$geoDist, 
                    coords = conStruct.data$coords, 
                    prefix = "spK3", 
                    n.chains = 1, 
                    n.iter = 1000, 
                    make.figs = TRUE, 
                    save.files = TRUE)



##############################################
############# SCRIPTING PROJECT ############## 
##############################################
#install.packages("plink")
#install.packages("radiator")
library(vcfR)
#library(plink)


setwd("/Users/claire/Desktop/Scripting/project/")

#vcf_data <- read.vcfR("Mikles_et_al._SongSparrows_MolecularEcology2020.vcf")
head(vcf)
vcf
help(conStruct)

#convert vcf to structure format

#plink --vcf vcf_data --recode structure --out Mikles_output.structure
mydata <- structure2conStruct(infile = "~/Desktop/Scripting/project/Mickles_data3.str",
                                        onerowperind = FALSE,
                                        start.loci = 3,
                                        start.samples = 2,
                                        missing.datum = -9,
                                        outfile = "~/Desktop/Scripting/project/Mickles_construct6")


localities <- read.csv("Mickles_latlong_reduced.csv")

localities <- localities[,2:3]
coords <- as.matrix(localities)
## running analyses

#vignette(topic="run-conStruct",package="conStruct")

my.run <- conStruct(spatial = FALSE, 
                    K = 4, 
                    freqs = mydata, 
                    geoDist = NULL, 
                    coords = coords,
                    prefix = "nspK2")
duplicated(mydata) #check if any individuals are identical 

localities[,1]

## Visualization

make.structure.plot(admix.proportions = admix.props, + sample.names = row.names(localities), + mar = c(4.5,4,2,2), sort.by = 1)

# make the desired map
maps::map(col="gray")

# add the admixture pie plot
make.admix.pie.plot(admix.proportions = admix.props,
                    coords = localities,
                    add = TRUE)
