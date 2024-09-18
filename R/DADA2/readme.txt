# DADA2 R script and SGE qsub file

This script was written using R/4.3.1 and work as both a script that runs in RStudio and as a batch job on a Linux server. The bash script is a jib submission file aimed at the SGE queuing system. 

The script can be copied/opened in RStudio and after changing the file paths for the results data folder and input data files can be run as any script. However, for typical data sets the script may take some time and so its best to run without interaction as a batch job from the terminal. To do this as a standard bash command, update the paths and filenames to suite your data and then issue the following command at a bash terminal prompt:

> R CMD BATCH \<script_filename>

If you are using a larger HPC that uses a queuing system such as SGE, modify the script as suggested above and then use the q_DADA2.sh script as follows

> qsub -v script=\<script_filename> q_DADA2.sh

The qsub script was developed on the HPC at the University of Leeds and requires the boost and R modules to be loaded before running the script. Other HPCs may need different modules to be loaded. The script requests 20Gb of RAM (#$ -l h_vmem=20G) and a run time of 24 hours (#$ -l h_rt=24:00:00), this is data dependant and so may need to be changed according to your needs. These parameters were requested for a job containing 191 sample files (~10.9 Gb) of MiSeq data.

When running the R script writes to the output stream indicating where it is and the time at which it reach that point in the script. script is derived from the code on the DADA2 [website](https://benjjneb.github.io/dada2/tutorial.html) and uses the taxonomy data that this page links too:

Link for taxonomy files: https://benjjneb.github.io/dada2/training.html
For version 138 download to Linux system with:
wget https://zenodo.org/records/4587955/files/silva_nr99_v138.1_train_set.fa.gz?download=1
wget https://zenodo.org/records/4587955/files/silva_species_assignment_v138.1.fa.gz?download=1

For version  132  download to Linux system with:l
wget https://zenodo.org/records/1172783/files/silva_nr_v132_train_set.fa.gz?download=1
wget https://zenodo.org/records/1172783/files/silva_species_assignment_v132.fa.gz?download=1

The site also suggests code for DECIPHER that requires the R file: "SILVA_SSU_r138_2019.RData" which can be accessed via the website.

The first 22 lines of the script are concerned with setting the values for the data file folder, results folder, job name and the taxonomy files mentioned above. 

If **DoDecipher <- TRUE** is used the data wiull be processed by _DECIPHER_, if its changed to **DoDecipher <- FALSE** it will not be processed.

The script can be run on either Windows or macOS/Linux OS's, but on Windows it can't multithread the **filterAndTrim** step, one of the first tasks of the script is to determine if the OS is Windows and set the *isNotWindows* variable, used by the **filterAndTrim** step.

The variables *forwardFileNamePatern* and *reverseFileNamePatern* should be set to the common text at the end of all the sample filenames. This text is then removed from the file names when used as more readible sample names in the outputed data.

Line 31 sets the location of the R package folder, if the script is run on a personal PC this should be deleted, but if you use a multiuser server and don't have admin rights this should be set to you library folder to which you have write permissions.

