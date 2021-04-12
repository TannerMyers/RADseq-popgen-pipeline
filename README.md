# RADseq Population Genomics
A pipeline for population genomic analysis of RADseq data developed for the Auburn University Scripting for Biologists course.

# Getting Started
- [Objectives](#objectives)
- [Data](#the-data)
- [Analyses](#methods)
	- [Stacks](#stacks)
	- [adegenet](#adegenet)
	- [admixture](#admixture)
	- [conStruct](#construct)
- [Sources](#sources)
- [References](#references)


## Objectives

Our pipeline is designed to take users from the step of obtaining restriction site-associated DNA sequence (RADseq) data from a sequencer to the beginning steps of population genomic inference. Specifically, we have provided scripts written in shell and R to demultiplex sequence data and assemble loci with `Stacks`, estimate population structure with both parametric and non-parametric population-clustering approaches (`Admixture` and `adegenet`), and to infer population structure under a spatially explicit model with `conStruct`.

## The Data

The scripts written to demultiplex and assemble raw sequence data with `Stacks` were tested on a double-digest RADseq (ddRADseq) dataset of 276 *Anolis distichus* lizards from the Bahamas, Haiti, and the Dominican Republic gathered by TM.

We also downloaded genomic data obtained from RADseq protocols and aligned using one of the two most popular assembly programs for RADseq, Stacks and PyRAD. 

The datasets we downloaded came from the following articles:

- Bouzid et al. 2021. Molecular Ecology.
	- [Dryad link](https://datadryad.org/stash/dataset/doi:10.5061/dryad.n5tb2rbv2)
	- This dataset includes filtered ddRADseq data for 108 *Sceloporus occidentalis* lizards collected across western North America.

- Quach et al. 2020. Biological Journal of the Linnean Society.
	- [Dryad link](https://datadryad.org/stash/dataset/doi%253A10.5061%252Fdryad.80gb5mkn4)
	- This dataset contains filtered SNP data (GBS protocol) obtained from 48 individuals of *Anolis cristatellus* from Puerto Rico, the Virgin Islands, and the island of Vieques. 

- Mikles et al. 2020. Molecular Ecology
	- [Dryad link](https://datadryad.org/stash/dataset/doi:10.5061/dryad.ncjsxkssb)
	- This dataset contains a filtered VCF file. Supplementary data including locality data for each individual is available in the supplemental data available in the [paper](https://onlinelibrary-wiley-com.spot.lib.auburn.edu/doi/full/10.1111/mec.15647#)


## Methods

### Stacks

`Stacks` is a pipeline used to assemble RADseq data and consists of wrappers written in Perl that are implemented in C++ Rochette & Catchen, 2019. The first step in the Stacks pipeline is `process_radtags`, which demultiplexes and cleans raw reads. Then, the main `Stacks` pipeline assembles loci within individuals with `ustacks`, identifies a catalog of loci with `cstacks` and then matches loci against the catalog with `sstacks`, and `tsv2bam` converts the .tsv files created in previous steps into .bam files. `gstacks` builds contigs by incorporating the paired-end reads, calls variants (SNPs), and genotypes samples. Then, users run `populations` to filter data, estimate population genetic parameters, and creates file formatted for input in population genetic and phylogenetic analysis software. We provide several shell and R scripts to guide your assembly of RADseq loci with `Stacks`.

Prior to running `Stacks`, we recommend formatting the directory in which you will be assembly RADseq loci according to the recommendations of [Rochette & Catchen (2017)](## References).

Users can run the script **run\_proc_radtags.sh** to execute `process_radtags`. You will need a tab-delimited file containing barcodes and sample IDs to provide names to the demultiplexed sample fastq files. Then, use **processradtags_results.sh** and **processradtags_results.r** to plot the number of retained reads for each individual in your dataset.

Prior to running `Stacks`, make a population map file consisting of tab-delimited columns of samples and their populations. Running the `Stacks` pipeline can be done by using either **run\_denovo_map.sh** or the **run\_stacks_pipeline.sh**. The **run\_denovo_map.sh** script uses `denovo_map`, a wrapper provided by `Stacks` that automates the pipeline, but this approach can be limited by large numbers of samples and is less flexible than just running each component of the pipeline individually. We recommend using the results from `process_radtags` to identify a subset of individuals to use **run\_denovo_map.sh** with to see the effect that different parameter values have on the number of loci and SNPs retained by Stacks (see Paris et al. (2017) for more information to guide your parameter value selection). The `Stacks` developers recommend setting the `-R` flag in the `populations` module to 0.80, requiring all loci that are retained to be found in 80% of the populations specified in your population map file.

Note: `Stacks` offers another wrapper that allows users to perform a reference genome-based assembly called `ref_map`. Following Paris et al. (2017), we used the integrated approach in which we assemble loci *de novo*, align the consensus assembled loci against the reference genome of a closely related species, and then integrate information from that alignment back into the assembled loci. The integrated approach was found to result in considerably more loci than use of `ref_map`. 

Once `Stacks` has completed for your subset of samples and the optimal parameter values have been identified, we recommend running it all the way through with all your samples using **run\_stacks_pipeline.sh**. If you are using a reference genome, follow the steps provided below. If not, remove the `bwa mem` and `stacks-integrate-alignments` lines from the script. 

***
Downloading and indexing a reference genome

- I downloaded the reference genome for *Anolis carolinensis* from the Ensembl database with this line of code: 
	- `rsync -av rsync://ftp.ensembl.org/ensembl/pub/release-101/fasta/anolis_carolinensis/dna/ .` 
	- Update the url for your reference genome

- I then ran the script **bwa_index.sh** to index the genome and create a reference genome database.	

***

After you run `Stacks` on your entire dataset, you may be dissatisfied by the number of loci recovered. There are both biological (e.g., allelic dropout) and experimental causes of missing data in RADseq datasets and both can diminish the quality of RADseq datasets. We provide a solution to remedy this issue using the protocol of Cerca et al. (2021), which uses `vcftools` to quantify the frequency of missing data in each individual within a population so that one can identify individuals with missing data frequencies higher than the population average and remove them from the dataset. First, split your population map file into many population maps for each population in your dataset. Then, make directories corresponding to each population. Using the same optimized parameters you identified for your whole dataset, execute **run\_stacks_pipeline.sh** for each individual population, outputting the files produced by `Stacks` to each population's directory. After `Stacks` completes for each population, run the script **individual-missing-data-assessment.sh**. The **bad_apples** file produced by the script will include the individuals with missing data exceeding their population's average missing data frequency. Drop these from your dataset unless their population's missing data average is lower than the dataset average (the "MEAN_MISSING" value in the log file), in which case keep the individuals below the missing data average. 

By following these steps, one can optimize the RADseq dataset obtained from `Stacks` by optimizing the `Stacks` parameters and filtering out low-quality individuals. At this stage, edit the flags provided to `populations` in **run\_stacks_pipeline.sh** to include your filtering strategies and your desired output file formats. 

### adegenet

The R package adegenet allows the user to perform genetic clustering on SNP sequence data.

Here, we will use an example dataset from Quach et al. (2020) to show the basics of how adegenet works. This is a dataset of 48 individuals of *Anolis cristatellus* from the island of Vieques. We will use the structure file from their Dryad repository (file extension .str) to import the dataset and perform a Discriminant Analyis of Principal Components (DAPC) to identify population clusters.

*Step 1 - Load the library and import the data*

Like any R package, start by installing and importing the package.

```
install.packages("adegenet")

library(adegenet)
```

Now, read in the data.

```
dat <- read.table("65filteredsinglepoly.str", head=FALSE)

lizards <- df2genind(dat, ploidy=1)
```
The initial file object, `dat`, is simply a table of the structure file with no header specified. There is a command in the adegenet package to directly upload a Structure file called `read.structure`, however it assumes diploidy in your dataset, which does not work well for what we have here. The second step reduces the ploidy of the dataset to 1 and allows the program to interpret these data better. There are multiple ways to import your data from fasta files and other file formats, so look into the documentation for adegenet and pick what works best for you.

*Step 2 - `find.cluster()`*

Next, you want to determine the appropriate number of clusters to use for your DAPC. DAPC requires you to have groups defined a priori. You may not always know this, so it is good to use an algorithm to determine the based k-value for your dataset. This function is not the most robust, and should be used only for exploratory analyses until you've approved the appropriate value of k through a different algorithm outside this package. We'll take a look at how it works anyway. The plot below shows cumulative variance explained on the y-axis and number of retained PCs on the x axis. The increasing pattern and horizontal asymptote visualize the pattern of decreasing information gained with more and more PCs retained.
```
grp <- find.clusters(lizards, max.n.clust=4)
```
First, the function performs a PCA on the data to reduce dimensionality. The authors of the package recommend keeping as many PCAs as possible because there is no reason to exclude information at this stage. Of course, PCs contain less and less information the further you get from the first so it may not matter as long as you retain a large number. Here we will just tell it to retain 200 to capture the maximum number of PCs in the dataset.

![pc1](https://github.com/TannerMyers/RADseq-popgen-pipeline/tree/main/images/pc1.png)

After that, the function will look for a number of clusters, producing a maximum of 4 possible (you can set this as high as you want). First, the function will output a plot of BIC values for each possible number of clusters up to the maximum value you have specified, in this case, integers ranging from 1 to 4. The lower the BIC value, the better. 

![BIC](https://github.com/TannerMyers/RADseq-popgen-pipeline/tree/main/images/BIC-plot.png)

Now, you have groups defined based on the k-value you chose.

*Step 3 - Run the DAPC*

Now for the actual analysis. Run the DAPC on your dataset with the groups defined in your grp item.
```
dapc1 <- dapc(lizards, grp$grp)
```
First, the function will again ask you how many PCs to retain. In this case you will want to not retain all of them but instead apply the "elbow rule" of cutting off the number of PCs you retain where the slope of the plot of cumulative variance starts to flatten. 

![pc2](https://github.com/TannerMyers/RADseq-popgen-pipeline/tree/main/images/pc2.png)

In this case, we will retain 50 PCs, which is around where the elbow of the plot seems to start.

After that, the program will show you a plot of discriminant function analysis eigenvalues (this is the special thing about DAPC). The higher the eigenvalue, the more information in that discriminant function. Discriminant functions serve the task of taking data with pre-defined groups (remember the k-value?) and maximizing inter-group variance while minimizing intra-group variance. In this case, since we only have a k-value of 2, we only retain 1 discriminant function, which is why the plot is just a big red brick (eigenvalues are calculated over matrices, and since we only have two groups we only have a 2x2 matrix, hence the single eigenvalue). Thus, we only have to say to retain 1 discrminant function, since the minimum to retain is 1 anyway, and we only have one to choose from. If you are dealing with a larger k-value, you will get multiple discriminant functions with the first being the largest (and most informative) and then decreasing, similar to a PCA. Often, the first 5 or so discriminant functions will have the information you need.

![discriminant](https://github.com/TannerMyers/RADseq-popgen-pipeline/tree/main/images/discriminant-eigs.png)

*Step 4 - Plot your results*

Last step is to plot your results. There are lots of fancy bells and whistles you can add to these plots, but we will keep it simple here.
```
scatter(dapc1)
```
![output](https://github.com/TannerMyers/RADseq-popgen-pipeline/tree/main/images/output-dapc.png)

Here, we can visualize the differences between groups. Oftentimes, if you have at least two discriminant functions, you will get a plot with multiple axes and dots plotted around spheres that encompass groups. Here, it is a simple density plot because we only have one discriminant function. However, it is easy to visualize the differences in genetic clustering between the two groups, and see where densities of points are the highest (more similar genotypes).

There is a lot more information you can get from the DAPC analysis such as which samples are sorted into which group, or what proportion of variance each allele contributes to. All of these tasks and more are well documented in the adegenet documentation. There is also a useful help forum on the adegenet Github repository that has answers to common mistakes.

### Admixture

`Admixture` is used to infer population structure and estimate ancestry. Unlike the approaches implemented in `adegenet`, `Admixture` implements a model-based framework to infer population structure similar to the program `STRUCTURE`. One advantage of `Admixture` and the reason why we chose to demonstrate it here is that the `Admixture` maximum likelihood estimation approach is much faster than `STRUCTURE`'s Bayesian implementation without sacrificing accuracy (Alexander et al., 2009).

 

Users planning to publish the results of their `Admixture` analyses will want to delve deeper into their data, but we hope that the introduction provided here is enough to get started.

### conStruct

All necessary R scripts are available in the conStruct folder within this repository. 

Input Data Required:
- STRUCTURE formatted file 
	- converted .vcf to .str file in [PGDSpider](http://www.cmpg.unibe.ch/software/PGDSpider/)
- Lat/Long data for each individual (csv)
- geoDistance matrix (only necessary for spatial runs - calculated in the conStruct script for a given set of lat/long points)

Output Data:
- "prefix"_model.fit.Robj
- "prefix"_data.block.Robj
- "prefix"_conStruct.results.Robj


## Sources
Sources for Programs:

- `Stacks`: [https://catchenlab.life.illinois.edu/stacks/](https://catchenlab.life.illinois.edu/stacks/)
- `adegenet`: [https://github.com/thibautjombart/adegenet/](https://github.com/thibautjombart/adegenet/)
- `Admixture`: [http://dalexander.github.io/admixture/download.html](http://dalexander.github.io/admixture/download.html)
- `ConStruct`: [https://github.com/gbradburd/conStruct](https://github.com/gbradburd/conStruct)

## References
> Alexander, D. H., J. Novembre, and K. Lange. 2009. Fast model-based estimation of ancestry in unrelated individuals. Genome Research 19: 1655–1664. doi: 10.1101/gr.094052.109.
>
> Bradburd, G. S., G. M. Coop, and P. L. Ralph. 2018. Inferring continuous and discrete population genetic structure across space. Genetics 210:33–52. doi: https://doi.org/10.1534/genetics.118.301333. 
>
> Cerca, J., M. F. Maurstad, N. C. Rochette, A. G. Rivera‐Colón, N. Rayamajhi, J. M. Catchen, and T. H. Struck. 2021. Removing the bad apples: A simple bioinformatic method to improve loci‐recovery in de novo RADseq data for non‐model organisms. Methods Ecol Evol 2041–210X.13562. doi: 10.1111/2041-210X.13562.
> 
> Jombart, T., and I. Ahmed. 2011. adegenet 1.3-1: new tools for the analysis of genome-wide SNP data. Bioinformatics 27:3070–3071. doi: 10.1093/bioinformatics/btr521.
> 
> Paris, J. R., J. R. Stevens, and J. M. Catchen. 2017. Lost in parameter space: a road map for stacks. Methods Ecol Evol 8:1360–1373. doi: 10.1111/2041-210X.12775.
> 
> Rochette, N. C., A. G. Rivera‐Colón, and J. M. Catchen. 2019. Stacks 2: analytical methods for paired‐end sequencing improve RADseq‐based population genomics. Mol Ecol 28:4737–4754. doi: 10.1111/mec.15253.
> 
> Rochette, N. C., and J. M. Catchen. 2017. Deriving genotypes from RAD-seq short-read data using Stacks. Nat Protoc 12:2640–2659. doi:10.1038/nprot.2017.123.


