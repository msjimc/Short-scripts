#!/bin/bash
##usage -t 1-n where n is number of bam files
## -v folder=<location of Bam files>,region=<chr1:nnnnnn-nnnnnn> i.e. chr14:105797511-107123963
#############################################
###Job submission config#####################
#############################################
# current environment and current working directory
#$ -V -cwd
# request time
#$ -l h_rt=00:30:00
#request memory per core
#$ -l h_vmem=500M
#request cores
#$ -pe smp 1
################################################
####Job Details#################################
################################################
##set path for Qualimap
export PATH=/home/marc1_a/msjimc/qualimap_v2.2.1/:$PATH
samtools="/home/home01/msjimc/samtools-1.3.1/samtools"


##Check for the folder of bam files
echo "Folder with bams:"
if [ -d "${folder}" ] ; then
    echo "Good $folder is OK";
elif [ -f "${folder}" ]; then
    echo "Error ${folder} is a file";
    exit 1
else
    echo "Error ${folder} is not valid";
    exit 1
fi

bam=$(ls $folder/*bam | sed -n -e "$SGE_TASK_ID p")
echo this bam file: $bam

echo $folder/region/
mkdir -p $folder/region
fname=`basename $bam`

$samtools view -bh $bam $region > $folder/region/$fname
$samtools index $folder/region/$fname

echo done