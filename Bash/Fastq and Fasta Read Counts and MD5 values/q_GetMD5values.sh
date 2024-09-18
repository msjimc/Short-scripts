#! /bin/bash
##usage folder=<folder of files>
#############################################
###Job submission config#####################
#############################################
# current environment and current working directory
#$ -V -cwd
# request time
#$ -l h_rt=24:00:00
# request memory per core
#$ -l h_vmem=100M
################################################
####Job Details#################################
################################################

sleep 2h

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



