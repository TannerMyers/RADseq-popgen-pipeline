# conStruct analysis

This folder contains the necessary files and R script to run a construct analysis. The following includes information to get started with your own conStruct analysis, along with details of calling the vignettes and data provided in the conStruct package to demonstrate the analyses. 

## Formatting Data

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



The following command will read in the structure formatted file and read it in as a conStruct dataset. 
```R
conStruct.data <- structure2conStruct(infile = "~/Desktop/myStructureData.str",
                                     onerowperind = TRUE,
                                     start.loci = 3,
                                     start.samples = 1,
                                     missing.datum = -9,
                                     outfile = "~/Desktop/myConStructData")
                                     ```


