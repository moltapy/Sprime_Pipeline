#! /bin/bash

download_1000genome=true
download_1000genome_highcoverage=false 
download_archaic_genome=true
download_plinkmap=true

if ${download_1000genome} ; then
mkdir 1000genome
cd 1000genome
wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL*
wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/integrated_call_samples_v3.20130502.ALL.panel
cd ../
fi

if ${download_1000genome_highcoverage} ; then
mkdir 1000genome_highcoverage
cd 1000genome_highcoverage
for chr in {2..2}
do
wget http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/1000G_2504_high_coverage/working/20190425_NYGC_GATK/CCDG_13607_B01_GRM_WGS_2019-02-19_chr${chr}.recalibrated_variants.vcf.gz
wget http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/1000G_2504_high_coverage/working/20190425_NYGC_GATK/CCDG_13607_B01_GRM_WGS_2019-02-19_chr${chr}.recalibrated_variants.vcf.gz.tbi
done
cd ../
fi


if ${download_archaic_genome} ; then

mkdir archaic_genome
cd archaic_genome

mkdir RecalledDenisova
cd RecalledDenisova
for chr in {22..22}
do
wget http://cdna.eva.mpg.de/neandertal/Vindija/VCF/Denisova/chr${chr}_mq25_mapab100.vcf.gz
wget wget http://cdna.eva.mpg.de/neandertal/Vindija/FilterBed/Denisova/chr${chr}_mask.bed.gz
done
cd ../

mkdir RecalledVindija
cd RecalledVindija

for chr in {22..22}
do
wget http://cdna.eva.mpg.de/neandertal/Vindija/VCF/Vindija33.19/chr${chr}_mq25_mapab100.vcf.gz
wget http://cdna.eva.mpg.de/neandertal/Vindija/FilterBed/Vindija33.19/chr${chr}_mask.bed.gz
done
cd ../../

fi

if ${download_plinkmap} ; then
mkdir plinkmap
cd plinkmap

wget http://bochet.gcc.biostat.washington.edu/beagle/genetic_maps/plink.GRCh37.map.zip
unzip plink.GRCh37.map.zip
touch plink.all.GRCh37.map

for chr in {1..22}
do
cat plink.chr${chr}.GRCh37.map >> plink.all.GRCh37.map
done

rm -f plink.chr* plink.GRCh37.map.zip

cd ../
fi
