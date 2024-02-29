#! /bin/bash
workmem="/public/group_data/he_yuan/Sprime/Pepline"
subgroup=../output/subgroup.txt
count=$(wc -l <"$subgroup")
run_sprime(){
    folder=$1
    gt=final/all.auto.vcf.gz
    map=../../../Data/GRCh37map/plink.all.GRch37.map
    cd ../output/subpops/$folder
    echo $(pwd)
    outgroup=../../outgroup.txt
    mkdir sprime_output
    for chr in {1..22}
    do
    out=sprime_output/$folder.yri.${chr}
    time java -jar ../../../Pepline/sprime.jar gt=${gt} outgroup=${outgroup} map=${map} out=${out} chrom=${chr} 
    done
    cd "$workmem"
}

export -f run_sprime

cat "$subgroup" | parallel -j $count "run_sprime {}"
