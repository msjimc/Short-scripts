#!/bin/bash
##Usage
## -v script=<script file>
#############################################
###Job submission config#####################
#############################################

# current environment and current working directory
#$ -V -cwd
# request time
#$ -l h_rt=24:00:00
#request memory per core
#$ -l h_vmem=20G
#request cores
#$ -pe smp 1

################################################
####Job Details#################################
################################################

echo Script: $script

module load boost/1.67.0
module load R/4.3.1

R CMD BATCH  $script

echo done
