# qsub submission files

These files are used to queue tasks on a HPC running the SGE queuing system. Each file contains a section where the number of processors, amount of RAM and run time is set. 
For eaxmple:
|Request|Comment|
|-|-|
|#$ -l h_rt=10:00:00|Request the task run for upto 10 hours|
|#$ -l h_vmem=8G|Request 8 Gb of RAM per processor/slot|
|#$ -pe smp 10|Request the task has access to 10 processors/slots|
