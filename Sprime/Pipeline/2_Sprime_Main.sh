#! /bin/bash
source 0_Extract_Sample_List.sh
source Merge_plink_Map.sh
# run sprime
outgroup=$outgroup_file
gt=$all_autos

for chr in {1..22}
do
map=$map_merge
#prefix
out=chb.yri.${chr}

eval "time java -jar sprime.jar gt=${gt} outgroup=${outgroup} map=${map} out=${out} chrom=${chr}" 
done