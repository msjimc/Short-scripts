#!/bin/bash
##Usage bash $HOME/scripts/b_Read_Counts_R1_only.sh <folder to put index in>

folder=$1

echo "File name	Counts" > $folder"/counts.txt"
echo  $folder"/counts.txt"

read=0
for fileName in $folder/*R1_001.fastq.gz
	do
		echo $fileName
		printf $(basename "$fileName")" \t" >> $folder"/counts.txt"
		##echo $(zcat $fileName | wc -l) / 4 | bc >> $folder"/counts.txt"
		r="$(zcat $fileName | wc -l)"
		let "r = ($r / 4)"
		echo $r >> $folder"/counts.txt"
		let "read = read + r"
	done

echo "" >> $folder"/counts.txt"

echo "Read counts	$read" >> $folder"/counts.txt"
	

echo done