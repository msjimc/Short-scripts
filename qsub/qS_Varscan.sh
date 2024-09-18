#!/bin/bash
##usage -t 1-n were n = number of samples
## -v folder=<folder of bam files>,bwaIndex=<location of BWA index>  
#############################################
###Job submission config#####################
#############################################
# current environment and current working directory
#$ -V -cwd
# request time
#$ -l h_rt=10:00:00
# request memory per core
#$ -l h_vmem=8G
# request cores
#$ -pe smp 4
################################################
####Job Details#################################
################################################

##set path for samtools and bwa
##export PATH=$HOME:$PATH
##export PATH=$HOME/bwa_0.7.12:$PATH
##export PATH=$HOME/BAMtoFastQ:$PATH

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
    echo "Error $bwaIndexis OK";
	exit 1
elif [ -f "${bwaIndex}" ]; then
    echo "Good ${bwaIndex} is a file";    
else
    echo "Error ${bwaIndex} is not valid";
    exit 1
fi

##Get the read1 fastq.gz file and its pair
bamFile=$(ls $folder/*.bam | sed -n -e "$SGE_TASK_ID p")
	echo read1.fastq.gz file: $fastqFile 

	echo Bam file: $bamFile

##get the file name to extract the name part
fname=`basename $bamFile`
	echo $fname file name
parentFolder="$(dirname "$folder")"
	echo $parentfolder parent folder	
	
prefix=$folder/${fname%".bam"*}
	echo "Base name:" $prefix


	echo Starting mpileup
$HOME/marcRootApps/samtools mpileup -f $bwaIndex $prefix.bam > $prefix.mpileup
	echo Starting SNP detection
java -jar $HOME/marcRootApps/VarScan.v2.3.7.jar pileup2snp $prefix.mpileup > $prefix.SNP
gzip $prefix.SNP

	echo Starting indel detection
java -jar $HOME/marcRootApps/VarScan.v2.3.7.jar pileup2indel $prefix.mpileup > $prefix.indel
gzip $prefix.indel

	echo Starting fastq production
$HOME/BAMtoFastQ/samtools mpileup -uf $bwaIndex $prefix.bam | $HOME/BAMtoFastQ/bcftools view -cg - | $HOME/BAMtoFastQ/vcfutils.pl vcf2fq > $prefix.fastq
gzip $prefix.fastq

	echo compressing mpileup file
gzip $prefix.mpileup

	echo Done 
	
		
##Make sure you have the most recent version of bcftools (v1.9). 
###$ bcftools mpileup -Ou -f ref.fa aln.bam | \
###bcftools call -Ou -mv | \
###bcftools norm -f ref.fa | \
###bcftools consensus -f ref.fa -o consensus.fa	