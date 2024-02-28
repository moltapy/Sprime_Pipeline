#! /bin/bash

hosts='p105|p106|p107|p108|p109|p110|p111|p112|p113|p114|p115|p116'

# concatenate all autosomes
echo "time bcftools concat --file-list vcf.file.list --naive --output-type z --output all.auto.vcf.gz" | qsub -q b-all.q -l h=${hosts} -N o.concat

