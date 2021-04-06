# anole-popgen
Scripts for population genomic analysis of RADseq data written for Auburn University Scripting course

**Objectives**

We will write a pipeline to perform population genomic analyses of SNP data obtained from reduced-representation genomic sequencing approaches. We will test our pipeline on a ddRADseq dataset obtained for nearly 300 individuals representing the Hispaniolan bark anole (*Anolis distichus*) species complex as well as other processed RADseq datasets downloaded from Dryad. The scripts we write will be used to demultiplex raw reads and assemble loci with the alignment program `Stacks` estimate population structure, and quantify gene flow across a landscape.

**Methods**

Methods to be included in our pipeline are `adegenet` and `STRUCTURE`/`ADMIXTURE` to infer population structure using both parametric and non-parametric methods and ConStruct to infer population structure in a spatially explicit fashion, accounting for potential isolation by distance.

**The Data**

*Insert more information about distichus ddRADseq data*

We also downloaded genomic data obtained from RADseq protocols and aligned using one of the main assembly programs for RADseq data, including Stacks and iPYRAD. 
The data we downloaded came from the following articles:

Bouzid et al. 2021. Molecular Ecology
*Insert dryad link*
*Include details like species, # of individuals, etc*

Quach et al. 2020. Biological Journal of the Linnean Society.
Dryad link: https://datadryad.org/stash/dataset/doi%253A10.5061%252Fdryad.80gb5mkn4
Contains x populations of Anolis cristatellus from Puerto Rico, including x individuals and filtered SNP data.

Sources for Potential Programs:
- `Stacks`:
- `adegenet`: https://github.com/thibautjombart/adegenet/
- `STRUCTURE`:
- `Admixture`:
- `ConStruct`: http://www.genescape.org/construct.html
