#!/bin/bash
## -v fasta=<location of BWA index>  
#############################################
###Job submission config#####################
#############################################
# current environment and current working directory
#$ -V -cwd
# request time
#$ -l h_rt=10:00:00
# request memory per core
#$ -l h_vmem=8G
################################################
####Job Details#################################
################################################

##set path for samtools and bwa
export PATH=<path to folder with samtools and bwa executibles>:$PATH

##Check for the file of fasta file
echo "Folder of files:"
if [ -d "${fasta}" ] ; then
    echo "Error $fasta is is a folder";
    exit 1
elif [ -f "${fasta}" ]; then
    echo "Good ${fasta} is a file";
else
    echo "Error ${fasta} is not valid";
    exit 1
fi

echo Indexing reference file with BWA
bwa index -a bwtsw $fasta

echo Indexing reference file with Samtools
samtools faidx $fasta

echo done