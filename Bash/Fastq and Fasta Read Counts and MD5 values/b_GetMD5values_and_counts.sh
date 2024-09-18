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

echo "File name	Counts" > $folder"/counts.txt"
echo  $folder/"counts.txt"

read=0
for fileName in $folder/*_001.fastq.gz
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