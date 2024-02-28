#! /bin/bash

# run sprime
hosts='p105|p106|p107|p108|p109|p110|p111|p112|p113|p114|p115|p116'


outgroup=../step2/outgroup.txt
gt=../step2/all.auto.vcf.gz

for chr in {1..22}
do
map=../download/plinkmap/plink.all.GRCh37.map
out=chb.yri.${chr}

echo "time java -jar ../tools/sprime.jar gt=${gt} outgroup=${outgroup} map=${map} out=${out} chrom=${chr}"  | qsub -q b-all.q -l h=${hosts} -N o.${chr} -pe local 12
done

