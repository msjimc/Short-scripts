#! /bin/bash
##usage bash scriptName folder=<folder of files>

folder=$1

 ##Check for the folder of fasta file
echo "Folder of files:"
if [ -d "${folder}" ] ; then
    echo "Good $folder is a folder";
elif [ -f "${folder}" ]; then
    echo "Error ${folder} is a file";
	exit 1
else
    echo "Error ${folder} is not valid";
    exit 1
fi

md5sum $folder/* > $folder"/md5values.txt"

echo done

echo "File name	Counts" > $folder"/counts_R1.txt"
echo  $folder/"counts_R1.txt"

read=0
for fileName in $folder/*R1_001.fastq.gz
	do
		echo $fileName
		printf $(basename "$fileName")" \t" >> $folder"/counts_R1.txt"
		##echo $(zcat $fileName | wc -l) / 4 | bc >> $folder"/counts_R1.txt"
		r="$(zcat $fileName | wc -l)"
		let "r = ($r / 4)"
		echo $r >> $folder"/counts_R1.txt"
		let "read = read + r"
	done

echo "" >> $folder"/counts_R1.txt"

echo "Read counts	$read" >> $folder"/counts_R1.txt"
	

echo done