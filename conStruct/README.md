# conStruct analysis

This folder contains the necessary files and R script to run a construct analysis. The following includes information to get started with your own conStruct analysis, along with details of calling the vignettes and data provided in the conStruct package to demonstrate the analyses. 

The full R script for data formatting and analysis is [construct_script_updated.R](https://github.com/TannerMyers/RADseq-popgen-pipeline/blob/main/conStruct/construct_script_updated.R).

## Formatting Data

Input Data:
- STRUCTURE formatted file (.str)
- locality data (.csv)
- geographic distance matrix

### Converting to STRUCTURE format
The input format for your RADseq data is STRUCTURE format. If you have a different file format (i.e. vcf file format) you can use PGDspider to covert to the desired file format. PGDSpider can be downloaded and run as a GUI, or can be run on the command line using bash. 

```bash
java -Xmx1024m -Xms512m -jar PGDSpider2-cli.jar

PGDSpider2-cli -inputfile <file> -inputformat <format> -outputfile <file> -outputformat <format> -spid <file>
```
Example script to covert from VCF to STRUCTURE format
```
PGDSpider2-cli  -inputfile examples\example_VCF.vcf -inputformat VCF
-outputfile examples\output_STRUCTURE.str -outputformat STRUCTURE -spid examples\Structure_Arlequin.spid
```

The following command will read in the structure formatted file and read it into R as a conStruct dataset. 
```R
conStruct.data <- structure2conStruct(infile = "~/Desktop/myStructureData.str",
                                     onerowperind = TRUE,
                                     start.loci = 3,
                                     start.samples = 1,
                                     missing.datum = -9,
                                     outfile = "~/Desktop/myConStructData")
 ```
### Reformatting locality data

The following command will load in a csv of locality with latitude in the second column, and longitude in the third column. It will then create a new variable with longitude as the first column and latitude as the second (as required to calculate the topographic distance). 
```R
localities <- read.csv("Mickles_latlong_reduced2.csv")
xy <- matrix(ncol=2, c(localities$Long, localities$Lat))
```

### Creating a geographic distance matrix

The following commands will load a digital elevation matrix (DEM) for the USA and load that as a dataset. This can be changed for the country of interest, and depending on the country the mask will need to be selected manually to include the portion of the country that the data is from. 
```R
raster::getData('alt', country='USA', mask=TRUE)
DEM <- raster("USA1_msk_alt.grd")
```
After loading in these files, you can create the geographic distance matrix using the topoDist command with your DEM file and your formatted localities. 
```R
tdist <- topoDist(DEM_crop$USA1_msk_alt,  
                  pts = xy_reduced, paths=FALSE) 
```

