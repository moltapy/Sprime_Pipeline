This pipeline is built on SPrime, which is a method for detecting the haplotypes in current-day populations that were introgressed from an archaic source in the past. 
In this pipeline, we detect Neanderthal and Denisovan introgression in 1000 Genomes Project data, specifically focusing on the CHB (Han Chinese in Beijing) population. For further details on the SPrime method, please refer to BROWNING et al. 2018

# Citation

> SPrime: S R Browning, B L Browning, Y Zhou, S Tucci, J M Akey (2018). Analysis of human sequence data reveals two pulses of archaic Denisovan admixture. Cell 173(1):53-61. doi: 10.1016/j.cell.2018.02.031

> Pipeline: Y Zhou, S R Browning (2021). Protocol for detecting archaic introgression variants with SPrime. Submitted.

Last update: 2/18/2021

# How to run this pipeline

1. Read the published protocol
2. Download the whole folder "pub.pipeline.pbs"
3. In the `pub.pipeline.pbs/download` folder, type `sh download.sh` to download all required resources
4. Start from `pub.pipeline.pbs/step2` to `pub.pipeline.pbs/step5`, type `sh run.sh` in each folder.

All codes are adapted to the Portable Batch System (PBS) based computation cluster.
