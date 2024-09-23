#!/bin/bash
##usage put -t 1-n in commandline after qsub and before any other stuff
## put '-v folder=<yourFolder>' for the path to the folder with no final '/' or speech marks
##  -hold_jid job_id_or_job_name

#############################################
###Job submission config#####################
#############################################
# current environment and current working directory
#$ -V -cwd
# request time
#$ -l h_rt=03:00:00
# request memory per core
#$ -l h_vmem=500M
# request cores
#$ -pe smp 1
################################################
####Job Details#################################
################################################

FastQC=<path to fastqc>/fastqc

echo Data folder: $folder
fastqFile=$(ls $folder/*fastq.gz | sed -n -e "$SGE_TASK_ID p")

mkdir -p $folder/Fastq_Report/temp;

$FastQC -o $folder/Fastq_Report/ --threads 1 --dir $folder/Fastq_Report/temp/ $fastqFile

echo done 