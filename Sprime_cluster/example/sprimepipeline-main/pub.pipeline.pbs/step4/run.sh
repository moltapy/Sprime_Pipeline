hosts='p105|p106|p107|p108|p109|p110|p111|p112|p113|p114|p115|p116'
#map variants to the Neanderthal genome
maparch="../tools/map_arch_genome/map_arch"

for chr in {1..22}; do

script=o.script.${chr}.sh

bedfile="../download/archaic_genome/RecalledVindija/chr${chr}_mask.bed.gz"
archaicfile="../download/archaic_genome/RecalledVindija/chr${chr}_mq25_mapab100.vcf.gz"
reftag="AltaiNean"
scorefile="../step3/chb.yri.${chr}.score"
outmscore="out.chr${chr}.mscore"; 
tmpprefix=../tmp/${RANDOM}

echo " 
time ${maparch} --kp --sep '\t' --tag ${reftag} \
        --mskbed ${bedfile} --vcf ${archaicfile} \
        --score ${scorefile} > ${tmpprefix}.tmp1.${chr}.mscore
" > ${script}

#map variants to the Denisovan genome
bedfile="../download/archaic_genome/RecalledDenisova/chr${chr}_mask.bed.gz"
archaicfile="../download/archaic_genome/RecalledDenisova/chr${chr}_mq25_mapab100.vcf.gz"
reftag="AltaiDeni"

echo " 
time ${maparch} --kp --sep '\t' --tag ${reftag} \
        --mskbed ${bedfile} --vcf ${archaicfile} \
        --score ${tmpprefix}.tmp1.${chr}.mscore > ${tmpprefix}.tmp2.${chr}.mscore 

mv ${tmpprefix}.tmp2.${chr}.mscore ${outmscore}
rm ${tmpprefix}.tmp*.${chr}.mscore 
rm ${script} 
" >> ${script}


qsub -q b-all.q -l h=${hosts} -N o.${chr} -pe local 12 ${script}

done

