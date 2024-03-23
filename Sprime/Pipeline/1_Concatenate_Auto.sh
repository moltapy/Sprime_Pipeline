#! /bin/bash
#工作路径始终指向你的Pipeline文件夹
#脚本的作用是将群体中所有vcf文件整合成为一个vcf文件
workmem="/public/group_data/Sprime/Pipeline"
for folder in ../output/subpops/*; do
    cd "$folder"
    mkdir -p final 
    vcf_file_list=vcf.file.list
    all_autos=final/all.auto.vcf.gz
    eval "time bcftools concat --file-list $vcf_file_list --naive-force --output-type z --output $all_autos" 
    cd "$workmem" 
done
