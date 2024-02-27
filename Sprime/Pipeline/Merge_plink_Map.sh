#!/bin/bash
map_merge=../Data/GRCh37map/plink.all.GRch37.map
for chr in {1..22}
do
#cat plink.chr${chr}.GRCh37.map >> plink.all.GRCh37.map
cat ../Data/GRCh37map/plink.chr${chr}.GRCh37.map >> $map_merge
done