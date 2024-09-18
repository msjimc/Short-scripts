# qsub submission files
## Setting the resource requests  

These files are used to queue tasks on a HPC running the SGE queuing system. Each file contains a section where the number of processors, amount of RAM and run time is set. 
For example:
|Request|Comment|
|-|-|
|#$ -l h_rt=10:00:00|Request the task run for up to 10 hours|
|#$ -l h_vmem=8G|Request 8 Gb of RAM per processor/slot|
|#$ -pe smp 10|Request the task has access to 10 processors/slots|

#### Location of messages sent by the tasks

When the jobs start they create a pair of files named after the script and the job ID number that appear in the current working directory. The files' name differ from each other by the presence of and 'e' or an 'o' after the job's ID number. 
* The 'e' file contains any message normally written to the error out stream - typically error messages
* The 'o' file contains message normally written to the standard oupt stream - typically status messages.
However, what is written to the two streams is not an absolute rule so the file may contain either type of message depending on how a program was written. 

#### Processing mutliple task with job arrays
Some qsub script are designed to process multiple files in parallel as job arrays. To make a job array you need to add the -t 1-n to the command line, where n is the number of tasks that need to be processed. When using a job array, each task gets its own 'e' and 'o' file with the tasks ID added to the end of the filename. 

## Comments on each qsub script file in this folder

### [q_bwa_index.sh](q_bwa_Index.sh)

This file creates a BWA index that is required for the alignment of sequence data to a genome using the bwa aligner. The script also prompts samtools to index the reference genome fasta file; indexed fasta files are required for some downstream programs and I put this step in here has it is convenient. 

***Usage***

> qsub -v fasta=\<genome reference filename> q_bwa_index.sh

 __Notes:__ The command requires the file paths to be included in the command.

 __Requirements:__ samtools and bwa need to be present on the server

 __Modifications:__ line 17 needs modifying so that the text in angled brackets is replaced by the name of the folder (with its path) that holds the bwa and samtools programs. The script's requirements are set for the indexing of the human genome (3 Gb) and may need adjusting for other species.

<hr />

### [qS_bwa_Index_multiple.sh](qS_bwa_Index_multiple.sh)

This script is very similar to q_bwa_index.sh, except it takes a folder of reference genomes (fasta files with the *.fa file extension) and creates a bwa index for each fasta file, as well as indexing the fasta files.  

***Usage***

> qsub -t 1-n -v folder=\<folder of genome reference files> q_bwa_index.sh

 __Notes:__ The the command requires the folder's and scripts paths to be included in the command. Since this script process a number of fasta files, it creates a job array with each genome processed by its own task. To make a job array you need to add the **-t 1-n** to the command line, where n is the number of fasta files to be processed.

 __Requirements:__ samtools and bwa need to be present on the server

 __Modifications:__ line 17 needs modifying so that the text in angled brackets is replaced by the name of the folder (with its path) that holds the bwa and samtools programs. The script's requirements are set for the indexing of the human genome (3 Gb) and may need adjusting for other species.

<hr />

 ### [qS_Cutadapt_Adaptor_file_Paired_end.sh](qS_Cutadapt_Adaptor_file_Paired_end.sh)

 This script processes pairs of Illumina sequencing data files (read 1 and read 2) with cutadapt and removes low quality bases from the 3' end of the reads plus sequences homologous to the sequencing adaptors. The sequence of the adaptors is in the [sequence.fasta](sequence.fasta) file. This contains a number of adaptor sequences and it may be quicker if the adaptors not in your files are removed.

 ***Usage***

> qsub -t 1-n -v folder=\<folder of sequencing files>,Read1Adaptors=<fasta file of adaptors> qS_Cutadapt_Adaptor_file_Paired_end.sh

*Note:* 
- The command is a single line   
- The filenames require the paths to be included.   
- The script runs as an job array and the 'n' should be replaced by the number of read pair files in the folder.
- There is no gap or space between the declarations of the variables: the 'Read1Adaptors' text follows straight after the comma. 


 __Requirements:__ cutadapt must be installed on the server. Cutadapt is a python program that is installed via pip, if you don't have admin rights for the server install cutadapt with:  

 > pip3 install --user --upgrade cutadapt

 The script expects the fastq files to be named with the standard Illumina format with read 1 files ending with **_R1_001.fastq.gz** and read 2 files ending with **_R2_001.fastq.gz**

 __Modifications:__ The HPC this script was developed on required python 3.7.4 to be made available by loading the python module (line 23: module load python/3.7.4) you may need to change this.

 <hr />

### [qS_BWA_Samtools_Order.sh](qS_BWA_Samtools_Order.sh)

This file uses BWA to align single end or paired read data to a BWA index created by the [q_bwa_index.sh](q_bwa_Index.sh) or (qS_bwa_Index_multiple.sh)[qS_bwa_Index_multiple.sh]. The script checks for the presence of the read 2 file to decide whether to use the single end alignment command or the paired end data command. 

Read data is aligned using the *mem* function which exports the data to a SAM file which then has the reads sorted by genome position and converted to a BAM file by samtools, which also indexes the BAM file. Line 88 finally deletes the SAM file, if you want to keep the SAM file comment out the line so it's: **# rm $prefix.sam**

The script also prompts samtools to index the reference genome fasta file; indexed fasta files are required for some downstream programs and I put this step in here has it is convenient. 

***Usage***

> qsub -t 1-n -v folder=<folder of fastq.gz files>,bwaIndex=<location of BWA index>,ID=<identifier> qS_BWA_Samtools_Order.sh

 __Notes:__ 
 - The command is a single line
 - The command requires the file paths to be included in the command.
 - The script runs as a job array with each job processing a single samples read data, to do this the 'n' needs changing to the number of samples in the folder.

 __Requirements:__ samtools and bwa need to be present on the server

 __Modifications:__ line 20 needs modifying so that the text in angled brackets is replaced by the name of the folder (with its path) that holds the bwa and samtools programs. The script's requirements are set for the alignment of ~ 30 million read pairs to the human genome (3 Gb) and may need adjusting for other species.

<hr />

### [qS_Samtools_Export_Region_From_Bam.sh](qS_Samtools_Export_Region_From_Bam.sh)

This script extracts reads mapping to a specific region in indexed BAM files in a folder. The region is submitted as:

 \<name of chromosome>:\<start point>-\<end point>  
i.e. 
- chr14:105797511-107123963
- 14:105797511-107123963
- NC_123456:105797511-107123963

The chromosome name or contig name may vary so some genomes have **chr1** while others may have **1**. SOme genome builds may have accession numbers like **NC_123456**.

The exported regions are formatted as BAM files which are also index. The new file and index are placed in subfolder called **region**. If the script is run multiple times the pervious regions are overwritten.

***Usage***

> qsub -t 1-n -v folder=<folder of Bam files>,region=<i.e chr14:105797511-107123963>

 __Notes:__ 
  - The command is a single line
 - The command requires the file paths to be included in the command.
 - The script runs as a job array with each job processing a single BAM file, to do this the 'n' needs changing to the number of BAM files in the folder.

 __Requirements:__ samtools need to be present on the server

 __Modifications:__ line 21 needs modifying so that the text in angled brackets is replaced by the name of the folder (with its path) that holds the samtools program. 

<hr />
