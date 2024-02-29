#! /bin/bash
workmem="/public/group_data/he_yuan/Sprime/Pepline"
for folder in ../output/subpops/*; do
    cd "$folder"
    mkdir final 
    vcf_file_list=vcf.file.list
    all_autos=final/all.auto.vcf.gz
    eval "time bcftools concat --file-list $vcf_file_list --naive-force --output-type z --output $all_autos" 
    cd "$workmem" 
done
