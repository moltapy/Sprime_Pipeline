##! /bin/bash
##不能用source，不然会重跑一遍
##source 0_Extract_Sample_List.sh
#mkdir ../output/final
#all_autos=../output/final/all.auto.vcf.gz
## 根据vcf.file.list合并vcf_file成为一个，并通过eval(类似python的execuable，执行字符串中的指令)
#eval "time bcftools concat --file-list $vcf_file_list --naive --output-type z --output $all_autos" 

#! /bin/bash
vcf_file_list=../output/vcf.file.list
mkdir ../output/final
all_autos=../output/final/all.auto.vcf.gz
# 根据vcf.file.list合并vcf_file成为一个，并通过eval(类似python的execuable，执行字符串中的指令)
#contig不同所以需要用-force
eval "time bcftools concat --file-list $vcf_file_list --naive-force --output-type z --output $all_autos" 


