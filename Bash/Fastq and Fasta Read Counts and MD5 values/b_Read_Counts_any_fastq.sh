#!/bin/bash
##Usage bash /home/marc1_a/msjimc/scripts/b_Read_Counts_R1_only.sh <folder to put index in>

folder=$1

echo "File name	Counts" > $folder"counts_fastq.txt"
echo  $folder"counts_fastq.txt"

read=0
for fileName in $folder/*.fastq.gz
	do

		echo $(basename "$fileName")
		printf $(basename "$fileName")": \t" >> $folder"/counts_fastq.txt"
		r="$(zcat $fileName | wc -l)"
		let "r = ($r / 4)"
		echo $r >> $folder"/counts_fastq.txt"
		let "read = read + r"
	done

echo "" >> $folder"/counts_fastq.txt"

echo "Read counts	$read" >> $folder"/counts_fastq.txt"
	let "read = read /2"
echo "If paired end data:" >> $folder"/counts_fastq.txt"
echo "Read1 counts	"$read >> $folder"/counts_fastq.txt"

