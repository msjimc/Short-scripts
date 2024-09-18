#!/bin/bash
##usage -t 1-n were n = number of samples
## -v folder=<folder of fastq.gz files>,bwaIndex=<location of BWA index>,ID=<identifier>  
#############################################
###Job submission config#####################
#############################################
# current environment and current working directory
#$ -V -cwd
# request time
#$ -l h_rt=24:00:00
# request memory per core
#$ -l h_vmem=8G
# request cores
#$ -pe smp 4
################################################
####Job Details#################################
################################################

##set path for samtools and bwa
samtools="/home/home01/msjimc/samtools-1.3.1/samtools"
bwa="/home/home01/msjimc/bwa-0.7.12/bwa"

echo bwa index $bwaIndex

##Check for the fastq.gz folder
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

echo "bwaIndex base file name:"
if [ -d "${bwaIndex}" ] ; then
    echo "Error $bwaIndexis";
	exit 1
elif [ -f "${bwaIndex}" ]; then
    echo "Good ${bwaIndex} is a file";    
else
    echo "Error ${bwaIndex} is not valid";
    exit 1
fi


##Get the read1 fastq.gz file and its pair
fastqFile=$(ls $folder/*_R1_001.fastq.gz | sed -n -e "$SGE_TASK_ID p")
	echo read1.fastq.gz file: $fastqFile 

read1=$fastqFile
read2=$(echo $read1 | sed 's/R1/R2/g')

	echo Read 1: $read1
	echo Read 2: $read2

##get the file name to extract the name part
fname=`basename $read1`
	echo $fname file name
parentFolder="$(dirname "$folder")"
	echo $parentfolder parent folder
prefix=$parentFolder/alignments$ID/${fname%"_L00"*}

	echo "Base name:" $prefix

mkdir -p $parentFolder/alignments$ID/


echo "Look for Read2 file:"
	
if [ -f "${read2}" ]; then
    echo "Good ${Read2} is a present"; 
	echo Start BWA with read pair
	$bwa mem -t 4 $bwaIndex $read1 $read2 > $prefix.sam
else
    echo "${Read2} is not present";
    echo Start BWA with single read 
	$bwa mem -t 4 $bwaIndex $read1 > $prefix.sam
fi


	echo Starting sorting
$samtools view -bS $prefix.sam | $samtools sort -o $prefix.bam
	echo making index
$samtools index $prefix.bam
	echo Remove sam file
rm $prefix.sam

	echo Done