#!/bin/bash
workmem="/public/group_data/he_yuan/Sprime/Pepline"
file="/public/group_data/he_yuan/Sprime/Samplelists/Original/sample_all.txtonly1000g"
subgroup_file="../output/subgroup.txt"
tail -n +2 "${file}" | awk '{print $2}' | sort | uniq > "${subgroup_file}"
while IFS= read -r line; do
    mkdir -p "../output/subpops/$line"
    awk -v name="$line" '$2==name{print $1}' "${file}" > "../output/subpops/$line/sample.txt"
done < "${subgroup_file}"

outgroup_file="../output/outgroup.txt"
grep YRI "${file}" | cut -f1 > "${outgroup_file}"

for folder in ../output/subpops/*; do
    cd "$folder"
    vcf_file_list=vcf.file.list
    > "$vcf_file_list"
    process_chr() {
        chr=$1
        vcf=/public/group_data/he_yuan/data/sekei/data_1kg/modern_v5b/chrom_${chr}.vcf.gz
        ovcf="chr${chr}.vcf.gz"
        echo "${ovcf}" >> vcf.file.list
        #下面这句是environment line4
        #注意sample-file中的sample.txt和上面的vcf.fil.list，全局变量和相对变量
        bcftools view --samples-file sample.txt $vcf | bcftools view -c1 -m2 -M2 -v snps | bcftools annotate -x INFO,^FORMAT/GT -Oz > "${ovcf}"
    }
    export -f process_chr
    seq 1 22 | parallel -j 22 process_chr 
    cd ${workmem}
done