# anole-popgen
Scripts for population and landscape genomic analysis written for Auburn University Scripting course

We will write a pipeline to perform population and landscape genomic analyses SNP data obtained from reduced-representation genomic sequencing approaches. We will test our pipeline a ddRADseq dataset of Anolis lizards previously obtained, but will be written such that it can be applied to any RadSeq data. Our scripts will utilize multiple methods, including EEMS (Estimated Effective Migration Surfaces) to analyze/visualize spatial population structure, ConStruct to infer discrete population structure, Circuitscape to analyze connectivity across the landscape, and outlier detection (potentially using BAYESCAN) and environmental association analyses to examine loci that are related to environmental variation (potentially using BAYENV or latent factor mixed models in R). EEMS is implemented in C++, Circuitscape is implemented in Julia, and BAYENV is written in C and interfaced in the command line.


Sources for Potential Programs:
- EEMS: https://github.com/dipetkov/eems
- ConStruct: http://www.genescape.org/construct.html
- Circuitscape: https://circuitscape.org
- BAYENV: https://gcbias.org/bayenv/
- BAYESCAN: http://cmpg.unibe.ch/software/BayeScan/
- Latent Factor Mixed Models: 
  - https://cran.r-project.org/web/packages/lfmm/vignettes/lfmm.html
  - https://bcm-uga.github.io/lfmm/
