#!/bin/bash

# Kill script if any commands fail
set -e
echo "Job Start at `date`"

sequence=/home/lww/raid/E.faecium_genome/geo_ef_head
list=/home/lww/raid/E.faecium_genome/mlst_result/class_result/list_mlst
cd /home/lww/raid/E.faecium_genome


for a in /home/lww/raid/E.faecium_genome/mlst_result/class_result/list_mlst/*
do 
dos2unix $a
a1=${a##*/}     #删掉最后一个 /  及其左边的字符串
a2=${a1%.*}     #删掉最后一个 . 及其右边的字符串
	for i in `cat ${list}/$a1`
	do 
	cat ${sequence}/${i} |seqkit amplicon -F GTGAAAATTATCGTTGACAATTTTTTTACG -R TTAAAGGAGCGGCGAAATCAATCTTGCTAA >> ex_cls1_$a2.txt
	done
done

for a in /home/lww/raid/E.faecium_genome/mlst_result/class_result/list_mlst/*
do 
dos2unix $a
a1=${a##*/}    
echo $a1
a2=${a1%.*}    
cat ex_cls1_$a1|seqkit subseq -r 805:807>269site_$a1
grep -c '^>' 269site_$a1>269site_total_$a1


cat $a1 | seqkit grep -i -s -r -C -p ^ACT >> 269m_num_${a1}
cat $a1 | seqkit grep -i -s -r -C -p ^ACC >> 269m_num_${a1}
cat $a1 | seqkit grep -i -s -r -C -p ^ACA >> 269m_num_${a1}
cat $a1 | seqkit grep -i -s -r -C -p ^ACG >> 269m_num_${a1}

cat 269m_num_$a1|awk '{sum1+= $1}END{print sum1}'>269m_sum_$a1
done

#get time end the job

echo "Job finished at: `date`"