#!/usr/bin/python
import os, sys, subprocess, time
from datetime import datetime

normalVCF = sys.argv[1]
tumourVCF = sys.argv[2]
outputVCF = sys.argv[3]

baseVariants = dict()

normalVCFFile = open(normalVCF, "r")
print ("Reading base sample: " + normalVCF)

for dataline in normalVCFFile:
    if (dataline.startswith("#") == False):
        items = dataline.split("\t")   
        if items[1] == "953279" and items[0] == "Chr1":
            print("found")     
        item = items[0] + " " + items[1] + " " + items[3] + " " + items[4] 
        baseVariants[item] = item

print ("Found:\t" + str(len(baseVariants)))
normalVCFFile.close()

all = 0
added = 0 
notAdded = 0

tumourVCFFile = open(tumourVCF, "r")
outputVCFFile = open(outputVCF, "w")
print ("Processing tumour sample: " + normalVCF)
for data in tumourVCFFile:
    if (data.startswith("#")  == True):
        outputVCFFile.write(data)
    else:
        all += 1
        items = data.split("\t")
        if items[1] == "953279" and items[0] == "Chr1":
            print("found")
        if items[6] == "PASS":
            item = items[0] + " " + items[1] + " " + items[3] + " " + items[4] 
            if (item in baseVariants) == False:
                outputVCFFile.write(data)
                added += 1
            else:
                notAdded += 1
        notAdded += 1

tumourVCFFile.close()
outputVCFFile.close()

print("Read\t" + str(all) + " in " + str(tumourVCF))
print ("Saved\t" + str(added))
print ("Rejected\t" + str(notAdded))
