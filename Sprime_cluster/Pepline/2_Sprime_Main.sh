#! /bin/bash
outgroup_file=../output/outgroup.txt
all_autos=../output/final/all.auto.vcf.gz
map_merge=../Data/GRCh37map/plink.all.GRch37.map
if [! ../output/sprime];then
    mkdir ../output/sprime
fi
# run sprime
outgroup=$outgroup_file
gt=$all_autos

for chr in {1..22}
do
map=$map_merge
#prefix
out=../output/sprime/chb.yri.${chr}

eval "time java -jar sprime.jar gt=${gt} outgroup=${outgroup} map=${map} out=${out} chrom=${chr}" 
done