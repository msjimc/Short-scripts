##Tested on R/4.3.1
##Settings to be chaged for specific task
print("setting parameters: 1");print("Time:");print(Sys.time()) 
fileBaseName <- "This_analysis"
print(fileBaseName)
workingFolder <- "<path too>/results/"
print(workingFolder)
dataFolder <- ""<path too>/data/"
print(dataFolder)
forwardFileNamePatern="_L001_R1_001.fastq.gz"
print(forwardFileNamePatern)
reverseFileNamePatern="_L001_R2_001.fastq.gz"
print(reverseFileNamePatern)

taxonomyData <- "<path too>/silva_nr99_v138.1_train_set.fa.gz"
print(taxonomyData)
speciesData <- "<path too>/silva_species_assignment_v138.1.fa.gz"
print(speciesData)
DECIPHERStateFile <- "<path too>/SILVA_SSU_r138_2019.RData"
print(DECIPHERStateFile)
DoDecipher <- TRUE
print(DoDecipher)

isNotWindows <- TRUE
if (Sys.info()["sysname"] == "Windows") {
  isNotWindows <- FALSE
}
print(isNotWindows)

## if working on multiuser server
.libPaths('/nobackup/msjimc/dada/R/')
##end settings of region

##Loading libraries
print("Loading libraries")
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install(version = "3.18", ask = FALSE )

if (!requireNamespace("dada2"))
    {BiocManager::install("dada2")}
library(dada2)
print("loaded")
## loaded libraries

dir.create(workingFolder, recursive = TRUE)
setwd(workingFolder)

#create file to write description in
print("Create file to write descripstion in: 2");print("Time:");print(Sys.time())
fileKey <- file(paste(workingFolder, "AnalysisDescription.txt", sep="/"), open = "wt")
print(fileKey)

##Set ground work
print("Set ground work: 3");print("Time:");print(Sys.time())
path <- dataFolder
list.files(path)
head(list.files(path))
dataFolder
# Forward and reverse fastq filenames editing
print("Forward and reverse fastq filenames editing : 4");print("Time:");print(Sys.time())
fnFs <- sort(list.files(path, pattern=forwardFileNamePatern, full.names = TRUE))
fnRs <- sort(list.files(path, pattern=reverseFileNamePatern, full.names = TRUE))

list.files(path, pattern=forwardFileNamePatern, full.names = TRUE)
list.files(path, pattern=reverseFileNamePatern, full.names = TRUE)

sample.names <- sapply(strsplit(basename(fnFs), "_"), `[`, 1)


##Inspect read quality profiles
print("Inspect read quality profiles: 5");print("Time:");print(Sys.time())

number = length(list.files(path, pattern=forwardFileNamePatern, full.names = TRUE))
print("Number of files is:")
print(number)
for (i in 1:number){
	imageName <- paste(i, "_A_forward.png")
	write(paste(imageName, ": Visualizing the quality profiles of the forward read.", sep="_"), fileKey, append = TRUE)
	png(imageName)
	  print(plotQualityProfile(fnFs[i:i]))
	dev.off()

	imageName <- paste(i, "_B_Reverse.png")
	write(paste(imageName, ": Visualizing the quality profiles of the reverse read.", sep="_"), fileKey, append = TRUE)
	png(imageName)
	  print(plotQualityProfile(fnRs[i:i]))
	dev.off()
}
##Filtering and trimming reads
print("Filtering and trimming reads: 6");print("Time:");print(Sys.time())
filtFs <- file.path(path, "filtered", paste0(sample.names, "_F_filt.fastq.gz"))
print("Done forward: 6.1");print("Time:");print(Sys.time()) 
filtRs <- file.path(path, "filtered", paste0(sample.names, "_R_filt.fastq.gz"))
print("Done reverse: 6.2");print("Time:");print(Sys.time()) 
names(filtFs) <- sample.names
names(filtRs) <- sample.names

out <- filterAndTrim(fnFs, filtFs, fnRs, filtRs, truncLen=c(240,160), maxN=0, maxEE=c(2,2), truncQ=2, rm.phix=TRUE, compress=TRUE, multithread=isNotWindows) # On Windows set multithread=FALSE
head(out)

## Save to files
print("Save stats to file: 7");print("Time:");print(Sys.time())
write.table(as.data.frame(out), file = paste(fileBaseName, "FilterAndTrimStats.xls", sep="_"), append = FALSE, quote = FALSE, sep = "\t",
            eol = "\n", na = "NA", dec = ".", row.names = TRUE,
            col.names = TRUE, qmethod = c("escape", "double"),
            fileEncoding = "")


##get the Error Rates
print("Getting error rates: 8");print("Time:");print(Sys.time())
errF <- learnErrors(filtFs, multithread=TRUE)
print("Forward done: 8.1");print("Time:");print(Sys.time())
errR <- learnErrors(filtRs, multithread=TRUE)
print("Reverse done: 8.2");print("Time:");print(Sys.time())

imageName <- "C.png"
write(paste(imageName, ": Visualizing the quality profiles of the forward read.", sep="_"), fileKey, append = TRUE)
png(imageName)
  print(plotErrors(errF, nominalQ=TRUE))
dev.off()

## Get sample inference
print("Getting sample inference and saving to file: 9");print("Time:");print(Sys.time())
dadaFs <- dada(filtFs, err=errF, multithread=TRUE)
dadaRs <- dada(filtRs, err=errR, multithread=TRUE)

##redirect output to screen as can't write directly to file
sink(paste(fileBaseName, "SampleInference_forward.txt", sep="_"))
  print(dadaFs)
sink()

sink(paste(fileBaseName, "SampleInference_Reverse.txt", sep="_"))
  print(dadaRs)
sink()

##Combine read pairs
print("Combining reads pairs: 10");print("Time:");print(Sys.time())
mergers <- mergePairs(dadaFs, filtFs, dadaRs, filtRs, verbose=TRUE)

sink(paste(fileBaseName, "ReadData.txt", sep="_"))
  print(mergers)
sink()

head(mergers[[1]])

##Create sequence table
print("Creating sequence table: 11");print("Time:");print(Sys.time())
seqtab <- makeSequenceTable(mergers)
dim(seqtab)
write.table(as.data.frame(seqtab), file = paste(fileBaseName, "ReadCountMatrix.xls", sep="_"), append = FALSE, quote = FALSE, sep = "\t",
            eol = "\n", na = "NA", dec = ".", row.names = TRUE,
            col.names = TRUE, qmethod = c("escape", "double"),
            fileEncoding = "")

# Inspect distribution of sequence lengths
print("Getting read length distribution: 12");print("Time:");print(Sys.time())
table(nchar(getSequences(seqtab)))
write.table(as.data.frame(table(nchar(getSequences(seqtab)))), file = paste(fileBaseName, "SequencelengthDistribution.txt", sep="_"), append = FALSE, quote = FALSE, sep = "\t",
            eol = "\n", na = "NA", dec = ".", row.names = TRUE,
            col.names = TRUE, qmethod = c("escape", "double"),
            fileEncoding = "")

## Remove chimeras
print("Removing chimeras: 13");print("Time:");print(Sys.time())
seqtab.nochim <- removeBimeraDenovo(seqtab, method="consensus", multithread=TRUE, verbose=TRUE)
dim(seqtab.nochim)
sum(seqtab.nochim)/sum(seqtab)

write.table(as.data.frame(seqtab.nochim), file = paste(fileBaseName, "ReadCountMatrix_No_Chimeras.xls", sep="_"), append = FALSE, quote = FALSE, sep = "\t",
            eol = "\n", na = "NA", dec = ".", row.names = TRUE,
            col.names = TRUE, qmethod = c("escape", "double"),
            fileEncoding = "")

## View removal stats
print("Getting removal stats: 14");print("Time:");print(Sys.time()) 
getN <- function(x) sum(getUniques(x))
track <- cbind(out, sapply(dadaFs, getN), sapply(dadaRs, getN), sapply(mergers, getN), rowSums(seqtab.nochim))
# If processing a single sample, remove the sapply calls: e.g. replace sapply(dadaFs, getN) with getN(dadaFs)
colnames(track) <- c("input", "filtered", "denoisedF", "denoisedR", "merged", "nonchim")
rownames(track) <- sample.names
head(track)

write.table(as.data.frame(track), file = paste(fileBaseName, "FileringReadStats.txt", sep="_"), append = FALSE, quote = FALSE, sep = "\t",
            eol = "\n", na = "NA", dec = ".", row.names = TRUE,
            col.names = TRUE, qmethod = c("escape", "double"),
            fileEncoding = "")


##assign taxonomy
print("Importing taxonomy data: 15");print("Time:");print(Sys.time()) 
taxa <- assignTaxonomy(seqtab.nochim, taxonomyData, multithread=TRUE)

if (file.exists(speciesData)) {
  print("Using species level data: 15a");print("Time:");print(Sys.time()) 
  taxa <- addSpecies(taxa, speciesData)
} else {
  print("Not using species level data; 15b");print("Time:");print(Sys.time()) 
}

taxa.print <- taxa # Removing sequence rownames for display only
rownames(taxa.print) <- NULL
head(taxa.print)

write.table(as.data.frame(taxa), file = paste(fileBaseName, "taxa_data.xls", sep="_"), append = FALSE, quote = FALSE, sep = "\t",
            eol = "\n", na = "NA", dec = ".", row.names = TRUE,
            col.names = TRUE, qmethod = c("escape", "double"),
            fileEncoding = "")


if (DoDecipher == TRUE)
{
print("Loading DECIPHER")
	if (!requireNamespace("DECIPHER"))
	  {BiocManager::install("DECIPHER")}
	library(DECIPHER)

	print("Loaded")

  print("Doing Dicipher stuff: 16");print("Time:");print(Sys.time())
  if (!requireNamespace("dada2"))
    {BiocManager::install("DECIPHER")}
  library(DECIPHER)
  
  dna <- DNAStringSet(getSequences(seqtab.nochim)) # Create a DNAStringSet from the ASVs
  load(DECIPHERStateFile) # CHANGE TO THE PATH OF YOUR TRAINING SET
  ids <- IdTaxa(dna, trainingSet, strand="top", processors=NULL, verbose=FALSE) # use all processors
  ranks <- c("domain", "phylum", "class", "order", "family", "genus", "species") # ranks of interest
  
  # Convert the output object of class "Taxa" to a matrix analogous to the output from assignTaxonomy
  taxid <- t(sapply(ids, function(x) {
          m <- match(ranks, x$rank)
          taxa <- x$taxon[m]
          taxa[startsWith(taxa, "unclassified_")] <- NA
          taxa
  }))
  
  print(taxid)
  
  colnames(taxid) <- ranks; rownames(taxid) <- getSequences(seqtab.nochim)
  colnames(taxid)
  rownames(taxid)
  head(taxid)
  
  sink(paste(fileBaseName, "Decipher_taxid.txt", sep="_"))
    print(taxid)
  sink()
}
## end alternative

## end of dada2 rest is example of visualisation
print("End of DADA2 stuff: 17");print("Time:");print(Sys.time())
