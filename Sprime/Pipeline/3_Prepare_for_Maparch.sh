#!/bin/bash
#同样，.......
workmem="/public/group_data/Sprime/Pepline"
maparch_process(){
    #还记得map_arch文件在哪对吗？
    maparch="/public/group_data/Sprime/tools/map_arch_genome/map_arch"
    chrom=$1
    for folder in /public/group_data/Sprime/output/subpops/*; do
    cd $folder
    name=$(basename $folder)
    mkdir -p match
    cd match
    script=o.script.${chrom}.sh
    bedfile="/public/group_data/Sprime/Data/Altai_13/mask_exclude/mask_final/chr_${chrom}_final_mask.bed.gz"
    archaicfile="/public/group_data/he_yuan/IBDmix_related/vcfs/altai/chr_${chrom}.vcf.gz"
    reftag="AltaiNean"
    scorefile=$folder/sprime_output/$name.yri.${chrom}.score
    outmscore="out.chr${chrom}.mscore"; 
    tmpprefix=$folder/tmp/${RANDOM}
    mkdir -p ../tmp

    echo "$maparch --kp --sep '\t' --tag ${reftag} \
--mskbed ${bedfile} --vcf ${archaicfile} \
--score ${scorefile} > ${tmpprefix}.tmp1.${chrom}.mscore
    " > ${script}

    #map variants to the Denisovan genome
    bedfile="/public/group_data/Sprime/Data/Denisovan/FilterBed/chr${chrom}_mask.bed.gz"
    archaicfile="/public/group_data/Sprime/Data/Denisovan/chr_${chrom}.vcf.gz"
    reftag="AltaiDeni"

    echo "$maparch --kp --sep '\t' --tag ${reftag} \
--mskbed ${bedfile} --vcf ${archaicfile} \
--score ${tmpprefix}.tmp1.${chrom}.mscore > ${tmpprefix}.tmp2.${chrom}.mscore 
mv ${tmpprefix}.tmp2.${chrom}.mscore ${outmscore}
rm ${tmpprefix}.tmp*.${chrom}.mscore 
rm ${script} 
    " >> ${script}
    cd $workmem
done
}

export -f maparch_process

seq 1 22 | parallel -j 22 maparch_process 