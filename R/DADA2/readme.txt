# DADA2 R script and SGE qsub file

This script was written using R/4.3.1 and work as both a script that runs in RStudio and as a batch job on a Linux server. The bash script is a jib submission file aimed at the SGE queuing system. 

The script can be copied/opened in RStudio and after changing the file paths for the results data folder and input data files can be run as any script. However, for typical data sets the script may take some time and so its best to run without interaction as a batch job from the terminal. To do this as a standard bash command, update the paths and filenames to suite your data and then issue the following command at a bash terminal prompt:

> R CMD BATCH \<script_filename>

If you are using a larger HPC that uses a queuing system such as SGE, modify the script as suggested above and then use the q_DADA2.sh script as follows

> qsub -v script=\<script_filename> q_DADA2.sh



webpage: https://benjjneb.github.io/dada2/tutorial.html
link for taxonomy files: https://benjjneb.github.io/dada2/training.html
for 138
wget https://zenodo.org/records/4587955/files/silva_nr99_v138.1_train_set.fa.gz?download=1
wget https://zenodo.org/records/4587955/files/silva_species_assignment_v138.1.fa.gz?download=1

for 132 in tutorial
wget https://zenodo.org/records/1172783/files/silva_nr_v132_train_set.fa.gz?download=1
wget https://zenodo.org/records/1172783/files/silva_species_assignment_v132.fa.gz?download=1
