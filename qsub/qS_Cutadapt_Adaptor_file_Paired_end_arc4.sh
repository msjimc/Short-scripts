#!/bin/bash

##Run using the qsub -t 1-n where n is the number of jobs
##then -v folder=<yourfolder>, (for the folder of fastq files, no space between comma and next variable)
##the Read1Adaptors=<fasta file of read1 adaptors> 
##finally script name

#############################################
###Job submission config#####################
#############################################
# current environment and current working directory
#$ -V -cwd
# request time
#$ -l h_rt=08:00:00
# request memory per core
#$ -l h_vmem=500M
# request cores
#$ -pe smp 1
################################################
####Job Details#################################
################################################

module load python/3.7.4

#python3 -m venv cutadapt-venv
#cutadapt-venv/bin/python3 -m pip install --upgrade pip
#cutadapt-venv/bin/pip install cutadapt


echo "Folder of files:"
if [ -d "${folder}" ] ; then
    echo "Good $folder is OK";
elif [ -f "${folder}" ]; then
    echo "Error ${folder} is a file";
    exit 1
else
    echo "Error ${folder} is not valid";
    exit 1
fi

echo "Read1 adaptors:"
if [ -d "${Read1Adaptors}" ] ; then
    echo "Error $Read1Adaptors is Folder";
    exit 1
elif [ -f "${Read1Adaptors}" ]; then
    echo "Good ${Read1Adaptors} is a file";
else
    echo "Error ${Read1Adaptors} is not valid";
    exit 1
fi

echo $folder folder 

fastqDir=$(ls $folder/*_R1_001.fastq.gz | sed -n -e "$SGE_TASK_ID p")

echo $fastqDir file 

read1=$fastqDir
read2=$(echo $read1 | sed 's/R1/R2/g')

echo Read2 file: $read1

fname=`basename $read1`
fname2=`basename $read2`

parentdir=`dirname $folder`
echo $parentdir "Parent folder"
mkdir -p $parentdir/trimmed/
trimmed_read1=$parentdir/trimmed/$fname
trimmed_read2=$parentdir/trimmed/$fname2


if [ -f $trimmed_read1 ] ; then
	rm $trimmed_read1
fi

if [ -f $trimmed_read1 ] ; then
	rm $trimmed_read1
fi

echo  -q 10 -m 30 -a file:$Read1Adaptors -A file:$Read1Adaptors -o $trimmed_read1 -p $trimmed_read2 $read1 $read2
$HOME/cutadapt-venv/bin/cutadapt -q 10 -m 30 -a file:$Read1Adaptors -A file:$Read1Adaptors -o $trimmed_read1 -p $trimmed_read2 $read1 $read2

echo done