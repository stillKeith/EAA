#!/bin/bash
#hard coded time, this is the amount of seconds the loadtest will run be allowed run. 
time=5

for i in {1..50}
do
#changed so would use i for the amount of cpu ./ loadtest.c $1
./loadtest $i &
cpu=`mpstat -o JSON $time 1 | jq '.sysstat.hosts[0].statistics[0]."cpu-load"[0].idle'`
#using hard coded time 
sleep $time

# kills the loadtest process
pkill loadtest

#counts the number of transactions completed 
cnt=`grep -c "Transaction Complete " synthetic.dat`
echo $cnt $i $cpu >> results.dat
echo $i  'Complete'

done
