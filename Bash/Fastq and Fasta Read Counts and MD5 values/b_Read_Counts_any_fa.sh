#!/bin/bash
##Usage bash /home/home01/msjimc/scripts/b_Read_Counts_any_fasta.sh <folder to put index in>

folder=$1

echo "File name	Counts" > $folder"/counts_fasta.txt"
echo  $folder"/counts_fasta.txt"

read=0
for fileName in $folder/*.fa.gz
	do
		
		echo $(basename "$fileName")
		printf $(basename "$fileName")": \t" >> $folder"/counts_fasta.txt"
		r="$(zcat $fileName | grep '>' | wc -l)"
		let "r = ($r / 2)"
		echo $r >> $folder"/counts_fasta.txt"
		let "read = read + r"
	done

echo "" >> $folder"/counts_fasta.txt"

echo "Read counts	$read" >> $folder"/counts_fasta.txt"



