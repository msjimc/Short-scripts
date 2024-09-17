# Filter tumour variants 

The folder contains two pytho scripts that removes germline variants in a VCF file derived from a pattient's health tissue from a VCF file derived from a a tumour sample. There are two scripts:

|Script|Function|
|-|-|
|p_FilterVCFwith2ndVCF_FMC.py|Removes variants from a tumour VCF file that are in a VCF file of variants from the patient's health tissue. If the same variant is seen in both files, it is removed only if it has the same genotype.|
|p_FilterVCFwith2ndVCF_genotypeFree_FMC.py|Removes variants from a tumour VCF file that are in a VCF file of variants from the patient's health tissue. If the same variant is seen in both files, it is removed what ever the variants genotype.|

When filtering variants, it may be desrirable to filter based on a change in the variants genotype. If a variant becomes homozygous in the tumour it may suggest that the region it which it is located has been lost from one chromosome in the sample. This may be an event you are interested in, in which case use the **p_FilterVCFwith2ndVCF_FMC.py** script. If your not interested in this use the **p_FilterVCFwith2ndVCF_genotypeFree_FMC.py** script.

## Usage

Both scripts use the same command structure:

> python p_FilterVCFwith2ndVCF_FMC.py \<normal sample VCF> \<tumour sample VCF> \<results VCF>

where:

|Parameter|Comment|
|-|-|
|python|Indicates its a python script to the terminal|
|p_FilterVCFwith2ndVCF_FMC.py| Name of script to be used. The path to the script is required if the script is not in the terminal current working directory|
|\<normal sample VCF>|Name of the VCF file (with path) containing the variants from the health tissue|
|\<tumour sample VCF>|Name of the VCF file (with path) containing the variants from the tumour sample|
|\<results VCF>|Name of the output VCF (with path) that will store the filtered variants|

The scripts only read the data in the fields in the variant file that are compulsory: the reference contig name, the variant's start point, the variants reference and alternative allele. The **p_FilterVCFwith2ndVCF_FMC.py** also reads the first 3 characters that normally contain the variants genotype (0/0 - homozygous wild type, 0/1 or 1/0 - heterozygous or 1/1 homozygous variant). The scripts also read the Filtering QC value in the 7th field and only process tumour variants that contain a _PASS_ value. Health tissue variants are not filtered for this score.

***Note***: When calling variants in a tumour sample they may not be given a genotype or all are given a heterozygous value. In these cases the filtering based on genotype will be meaningless.