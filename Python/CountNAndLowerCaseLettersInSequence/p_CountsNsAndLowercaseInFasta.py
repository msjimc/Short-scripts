#!/usr/bin/python
import os, sys
import gzip
import shutil
from collections import Counter
from decimal import *

fileName = sys.argv[1] 

index =  fileName.rfind(".fa")
path = fileName[0:index]
newFastaFilename = path + "_clean.fa"
newexFastaFilename = path + "_Excluded.fa"
newTextFilename = path + "_stats.txt"

items = []
counter = 1

name=""
sequence=""
count=0
gc=0
percent=0.0
writeTooFA = open(newFastaFilename, "w")	
writeTooTxT = open(newTextFilename, "w")	
writeTooExcluded = open(newexFastaFilename, "w")	

index =  fileName.rfind(".fa")
if ( index == len(fileName) - 2 ):
    print("Compressed file")
    file = gzip.open(fileName, "rt")
else:
    print("Uncompressed file")
    file = open(fileName, "r")


for x in file:
    if (x.startswith('>') == True):
        if (len(sequence) > 0):
            counter = Counter(sequence)
            count = counter['c']
            count += counter['g']
            gc = count
            gc += counter['G']
            gc += counter['C']
            count += counter['a']
            count += counter['t']
            count += counter['N']
            count += counter['n']
            percent = Decimal(gc * 100) / Decimal(len(sequence))
            writeTooTxT.write(name[1:len(name)-1] + "\t" + str(count) + "\t" + str(len(sequence)) + "\t" + str(percent)[0:4] + "\n")
            print(name[1:len(name)-1] + "\t" + str(count) + "\t" + str(len(sequence)) + "\t" + str(percent)[0:4])
            if (count > 0):
                writeTooFA.write(name + sequence + "\n")
                sequence=""
            else:
                writeTooExcluded.write(name + sequence + "\n")
                sequence=""
        name=x
    else:
        sequence+=x[0:len(x)-1]

if (len(sequence) > 0):
    counter = Counter(sequence)
    count += counter['a']
    count += counter['c']
    count += counter['g']
    count += counter['t'] 
    count += counter['N']
    count += counter['n']
    writeTooTxT.write(name[1:len(name)-1] + "\t" + str(count) + "\t" + str(len(sequence)) + "\t" + str(percent)[0:4] + "\n")
    if (count > 0):
        writeTooFA.write(name + sequence + "\n")
    else:
        writeTooExcluded.write(name + sequence + "\n")

file.close
writeTooFA.close
writeTooTxT.close
writeTooExcluded.close
