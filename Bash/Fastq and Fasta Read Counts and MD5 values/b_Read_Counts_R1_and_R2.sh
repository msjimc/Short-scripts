#!/bin/bash
##Usage bash $HOME/scripts/b_Read_Counts_R1_and_R2.sh <folder of fastq files>

folder=$1

echo "File name	Counts" > $folder"/counts.txt"
echo  $folder"/counts.txt"

read=0
for fileName in $folder/*_001.fastq.gz
	do
		
		echo $(basename "$fileName")
		printf $(basename "$fileName")": \t" >> $folder"/counts.txt"
		r="$(zcat $fileName | wc -l)"
		let "r = ($r / 4)"
		echo $r >> $folder"/counts.txt"
		let "read = read + r"
	done

echo "" >> $folder"/counts.txt"

echo "Read counts	$read" >> $folder"/counts.txt"
	let "read = read /2"
echo "Read1 counts	"$read >> $folder"/counts.txt"

