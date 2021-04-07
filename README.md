# anole-popgen
Scripts for population genomic analysis of RADseq data written for Auburn University Scripting course

****Objectives****

We will write a pipeline to perform population genomic analyses of SNP data obtained from reduced-representation genomic sequencing approaches. We will test our pipeline on a ddRADseq dataset obtained for nearly 300 individuals representing the Hispaniolan bark anole (*Anolis distichus*) species complex as well as other processed RADseq datasets downloaded from Dryad. The scripts we write will be used to demultiplex raw reads and assemble loci with the alignment program `Stacks` estimate population structure, and quantify gene flow across a landscape.

***Methods***

Methods to be included in our pipeline are `adegenet` and `STRUCTURE`/`ADMIXTURE` to infer population structure using both parametric and non-parametric methods and ConStruct to infer population structure in a spatially explicit fashion, accounting for potential isolation by distance.

**adegenet**

The R package adegenet allows the user to perform genetic clustering on SNP sequence data.

Here, we will use an example dataset from Quach et al. (2020) to show the basics of how adegenet works. This is a dataset of 48 individuals of Anolis cristatellus from the island of Vieques. We will use the structure file from their Dryad repository (file extension .str) to import the dataset and perform a simple DAPC genetic clustering analysis.

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

In this case, I will retain 50 PCs, which is around where the elbow of the plot seems to start.

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

***The Data***

*Insert more information about distichus ddRADseq data*

We also downloaded genomic data obtained from RADseq protocols and aligned using one of the main assembly programs for RADseq data, including Stacks and iPYRAD. 
The data we downloaded came from the following articles:

Bouzid et al. 2021. Molecular Ecology
*Insert dryad link*
*Include details like species, # of individuals, etc*

Quach et al. 2020. Biological Journal of the Linnean Society.
Dryad link: https://datadryad.org/stash/dataset/doi%253A10.5061%252Fdryad.80gb5mkn4
Contains 379 mtDNA samples of Anolis cristatellus from Puerto Rico, the Virgin islands, and the island of Vieques  including 48 individuals for which there are filtered SNP data.

Sources for Programs:
- `Stacks`:
- `adegenet`: https://github.com/thibautjombart/adegenet/
- `STRUCTURE`:
- `Admixture`:
- `ConStruct`: http://www.genescape.org/construct.html
