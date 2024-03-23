#!/bin/bash
#同样，...记住上一步只是生成了sh文件，但是还没开始运行
workmem="/public/group_data/Sprime/Pepline"
chmod +x /public/group_data/Sprime/tools/map_arch_genome/map_arch
for folder in /public/group_data/he_yuan/Sprime/output/subpops/*; do
    cd $folder/match 
    parallel -j 22 bash o.script.{}.sh ::: {1..22}
    echo "finish $folder" 
    cd $workmem
done