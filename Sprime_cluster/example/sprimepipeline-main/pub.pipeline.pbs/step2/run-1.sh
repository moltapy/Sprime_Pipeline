#! /bin/bash

hosts='p105|p106|p107|p108|p109|p110|p111|p112|p113|p114|p115|p116'

# Extract YRI and CHB samples for each chromosome
file=../download/1000genome/integrated_call_samples_v3.20130502.ALL.panel
grep -E "(YRI|CHB)" ${file} | cut -f1 > sample.txt
grep YRI ${file} | cut -f1 > outgroup.txt

echo -n "" > vcf.file.list

for chr in {1..22}
do
vcf=../download/1000genome/ALL.chr${chr}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz
ovcf=../tmp/chr${chr}.vcf.gz
echo ${ovcf} >> vcf.file.list
echo "time bcftools view --samples-file sample.txt ${vcf} | bcftools view -c1 -m2 -M2 -v snps | bcftools annotate -x INFO,^FORMAT/GT -Oz > ${ovcf}" | qsub -q b-all.q -l h=${hosts} -N o.${chr} -pe local 12
done
