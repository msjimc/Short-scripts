#!/bin/bash
##Usage bash /home/home01/msjimc/scripts/b_Read_Counts_any_fasta.sh <folder to put index in>

folder=$1

echo "File name	Counts" > $folder"counts.txt"
echo  $folder"counts.txt"

read=0
for fileName in $folder/*.fasta
	do
		echo $(basename "$fileName")
		printf $(basename "$fileName")": \t" >> $folder"/counts.txt"
		r="$(cat $fileName | wc -l)"
		let "r = ($r / 2)"
		echo $r >> $folder"/counts.txt"
		let "read = read + r"
	done

echo "" >> $folder"/counts.txt"

echo "Read counts	$read" >> $folder"/counts.txt"
	let "read = read /2"

