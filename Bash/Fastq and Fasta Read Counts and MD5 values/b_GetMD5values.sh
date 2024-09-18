#! /bin/bash
##usage bash scriptName folder=<folder of files>

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



