#!/bin/bash
## -t 1-n -v folder=<location of fasta files>  
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
if [ -d "${folder}" ] ; then
    echo "Good $folderis is a folder";
elif [ -f "${folder}" ]; then
    echo "Error ${folder} is a file";
    exit 1
else
    echo "Error ${folder} is not valid";
    exit 1
fi

##Get the read1 fastq.gz file and its pair
fastaFile=$(ls $folder/*.fa | sed -n -e "$SGE_TASK_ID p")
	echo FastA file: $fastaFile 

echo Indexing reference file with BWA
bwa index -a bwtsw $fastaFile 

echo Indexing reference file with Samtools
samtools faidx $fastaFile 



echo done