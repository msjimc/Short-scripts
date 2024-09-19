# Fasta and Fastq record counts and MD5 values

## Counts

Fasta and fastq are typically used to hold sequence data and may contain 1 or more sequences. Read sequences from Illumina sequencers tend to be stored in fastq files compressed with gzip, while fasta file are used to store sequence data from a wide range sources. Whatever they are, it can be important to count the number of records in each file, especially when working with sequencing data and you want to see how many reads each sample as. The scripts in this folder allow you to process a folder of files and count the reads in each file with the results stored in a text file. Each script does something slightly different from the others as outlined in the table below.
Fasta and fastq are typically used to hold sequence data and may contain 1 or more sequences. Read sequences from Illumina sequencers tend to be stored in fastq files compressed with gzip, while fasta files are used to store sequence data from a wide range sources. Whatever they are, it can be important to count the number of records in each file, especially when working with sequencing data and you want to see how many reads each sample has. The scripts in this folder allow you to process a folder of files and count the reads in each file with the results stored in a text file. Each script does something slightly different from the others as outlined in the table below.

## MD5

When downloading large files it may be good to know whether they have been corrupted. This is normally done by comparing the MD5 values before and after the download. To create the MD5 values on Linux, you'd tend to use md5sum, some of the scripts below create a file containing these values which can then be used by other people that have downloaded the data to check for errors 

|Script|Purpose|
|-|-|
|b_Read_Counts_any_fa.sh|Gets read count for a folder of gzip __compressed__ fasta files with the __*.fa.gz__ file extension |
|b_Read_Counts_any_fasta.sh|Gets read count for a folder of gzip __compressed__ fasta files with the __*.fasta.gz__ file extension|
|b_Read_Counts_any_fastq.sh|Get read count for a folder of gzip __compressed__ fastq files with the __*.fastq.gz__ file extension|
|b_Read_Counts_any_fq.gz.sh|Get read count for a folder of gzip __compressed__ fastq files with the __*.fq.gz__ file extension|
|b_Read_Counts_R1_and_R2.sh|Get read count for a folder of gzip __compressed__ fastq files with the __*001.fastq.gz__ file suffix and extension. This typically for a folder of Illumina sequences read 1 and 2 files|
|b_Read_Counts_R1_only.sh|Get read count for a folder of gzip __compressed__ fastq files with the __*R1_001.fastq.gz__ file suffix and  extension. This typically for a folder of Illumina sequences read 1 and 2 files, when you don't want to waste time counting the read 2 reads which should match the sample's read 1 count|
|b_Read_Counts_any_uncompressed_fasta.sh|Gets read count for a folder of __uncompressed__ fasta files with the __*.fasta__ file extension|
|b_GetMD5values_and_counts.sh|Same as __b_Read_Counts_any_fq.gz.sh__, but also creates a MD5 file|
|b_GetMD5values_and_counts_R1_only.sh|Same as b___Read_Counts_R1_only.sh__, but also creates a MD5 file|
|b_GetMD5values.sh|Creates a file of MD5 values from anything in a folder|
|q_GetMD5values.sh|Creates a file of MD5 values from anything in a folder, but is run as a qsub submission job|


## Usage

All the scripts starting with a __b___ use the following command:

> bash \<script name> \<folder with path to be processed>

The qsub script (starts with __q____) is used with the command:

> qsub -v folder=\<folder with path to be processed> q_GetMD5values.sh

***Note***: All references to files need the relevant path information