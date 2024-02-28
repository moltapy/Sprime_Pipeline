#! /bin/bash

#hosts='p105|p106|p107|p108|p109|p110|p111|p112|p113|p114|p115|p116'

#.panel文件是一个包含样本的文本文件
#file=../download/1000genome/integrated_call_samples_v3.20130502.ALL.panel
#跑的是1kgmerge227
file=$0
sample_file=../output/sample.txt
outgroup_file=../output/outgroup.txt
vcf_file_list=../output/vcf.file.list
mkdir ../output/tmp
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
vcf=/public/group_data/he_yuan/TIB_phased_200_ref_merge1kg/chrom_${chr}.vcf.gz
ovcf=../output/tmp/chr${chr}.vcf.gz
echo ${ovcf} >> $vcf_file_list
#只提取sample.txt中的样本，并保留双等位snp位点，使用INFO等注释加上，并将结果输出成为ovcf
#echo "time bcftools view --samples-file sample.txt ${vcf} | bcftools view -c1 -m2 -M2 -v snps | bcftools \
#annotate -x INFO,^FORMAT/GT -Oz > ${ovcf}" \
#| qsub -q b-all.q -l h=${hosts} -N o.${chr} -pe local 12
eval "bcftools view --samples-file $sample_file ${vcf} | bcftools view -c1 -m2 -M2 -v snps | bcftools annotate -x INFO,^FORMAT/GT -Oz > ${ovcf}"
done
