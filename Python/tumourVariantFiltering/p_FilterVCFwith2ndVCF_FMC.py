#!/usr/bin/python
import os, sys, subprocess, time
from datetime import datetime

normalVCF = sys.argv[1]
tumourVCF = sys.argv[2]
outputVCF = sys.argv[3]

print("Normal " + normalVCF)
print("Tumour: " + tumourVCF)

baseVariants = dict()

normalVCFFile = open(normalVCF, "r")
print ("Reading base sample: " + normalVCF)

for dataline in normalVCFFile:
    if (dataline.startswith("#") == False):
        items = dataline.split("\t")        
        item = items[0] + " " + items[1] + " " + items[3] + " " + items[4] 
        if (items[9].startswith("0/1") == True):
            item += " 0/1"
        elif (items[9].startswith("1/1") == True):
            item += " 1/1"
        elif (items[9].startswith("1/0") == True):
            item += " 0/1"
        baseVariants[item] = item

print ("Found:\t" + str(len(baseVariants)))
normalVCFFile.close()

all = 0
added = 0 
notAdded = 0

tumourVCFFile = open(tumourVCF, "r")
outputVCFFile = open(outputVCF, "w")
print ("Processing tumour sample: " + tumourVCF)
for data in tumourVCFFile:
    if (data.startswith("#")  == True):
        outputVCFFile.write(data)
    else:
        all += 1
        items = data.split("\t")
        if items[6] == "PASS":
            item = items[0] + " " + items[1] + " " + items[3] + " " + items[4] 
            if (items[9].startswith("0/1") == True):
                item += " 0/1"
            elif (items[9].startswith("1/1") == True):
                item += " 1/1"
            elif (items[9].startswith("1/0") == True):
                item += " 0/1"
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
