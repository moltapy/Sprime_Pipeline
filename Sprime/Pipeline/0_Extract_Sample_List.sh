#! /bin/bash

#.panel文件是一个包含样本的文本文件
#file=../download/1000genome/integrated_call_samples_v3.20130502.ALL.panel
#一次只能包含一个subgroup和一个outgroup，所以要将其按照subgroup分别提取并撞到文件夹中，再分配任务并行
#跑的是1kgmerge227,但是因为./.会报missing错误，先跑1KG
#外部传参首先要从1开始
#file=/public/group_data/he_yuan/Sprime/Samplelists/Original/sample_all.txtonly1000g
file= $1
subgroup_file=../output/subgroup.txt
awk '{print $2}' $file | sort | uniq > $subgroup_file
while IFS= read -r line; do
    mkdir "$line"
done < $subgroup_file
outgroup_file=../output/outgroup.txt
vcf_file_list=../output/vcf.file.list
if [ -d "../output/tmp"];then
    echo "存在，跳过"
else
    mkdir ../output/tmp
fi
#分别将YRI、CHB提取出来形成samplelist。
#grep -E "(YRI|CHB)" ${file} | cut -f1 > sample.txt
#追加samplelist，file前后不能有{}
tail -n +2 $file | cat |cut -f1 > $sample_file
#因为echo可以，认为显示都是可以导出
grep YRI ${file} | cut -f1 > $outgroup_file

echo -n "" > $vcf_file_list

for chr in {1..22}
do
#vcf=../download/1000genome/ALL.chr${chr}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz
vcf=/public/group_data/he_yuan/data/sekei/data_1kg/modern_v5b/chrom_${chr}.vcf.gz
ovcf=../output/tmp/chr${chr}.vcf.gz
echo ${ovcf} >> $vcf_file_list
#只提取sample.txt中的样本，并保留双等位snp位点，使用INFO等注释加上，并将结果输出成为ovcf
#echo "time bcftools view --samples-file sample.txt ${vcf} | bcftools view -c1 -m2 -M2 -v snps | bcftools \
#annotate -x INFO,^FORMAT/GT -Oz > ${ovcf}" \
#| qsub -q b-all.q -l h=${hosts} -N o.${chr} -pe local 12
eval "bcftools view --samples-file $sample_file ${vcf} | bcftools view -c1 -m2 -M2 -v snps | bcftools annotate -x INFO,^FORMAT/GT -Oz > ${ovcf}"
done