#!/bin/bash

process=$1
echo process: $process

results=$(qacct -j $process)

lastLinne=""
let wall=0
let cpu=0
let slots=0
maxvmem="0"
let count=0;
for line in $results ; do

	if [[ $lastLinne = "ru_wallclock" ]] ; then
		let wall=${line%"s"}
	elif [[ $lastLinne == "failed" ]] ; then
		fail=$line
	elif [[ $lastLinne == "taskid" ]] ; then
		echo "##################################"
		echo "Task ID: "$line
	elif [[ $lastLinne == "exit_status" ]] ; then
		ended=$line
		echo "Teminated: "$fail", "$ended		
	elif [[ $lastLinne == "cpu" ]] ; then
		 cpu=${line%"."*}
	elif [[ $lastLinne == "slots" ]] ; then
		let slots=$line
	elif [[ $lastLinne == "maxvmem" ]] ; then
		maxvmem=$line
		echo cpu time $cpu
		echo Run time $wall
		echo Processors $slots
		let answer=$cpu\*100/$wall
		let answer=$answer/$slots
		echo $answer"% of time processing"
		echo Total memory $maxvmem
		let count=$count+1
	fi
lastLinne=$line

done

echo "##################################"
echo Number of jobs = $count

echo s"cript end"
