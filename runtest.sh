#!/bin/bash
#hard coded time, this is the amount of seconds the loadtest will run be allowed run. 
time=5
# for loop repeats 
for i in {1..50}
do
#runs the loadtest code
#it uses the i variable from the for loop as the number of users in the system 
./loadtest $i &
#sleep tells the program how long to wait before going to the next line
sleep $time
#mpstat shows what the cpu is doing 
#its being dispalyed in JSON this makes it easier to filter what we are looking for 
#we are only intrested in the cpu idle time. 
#we get this before killing the process as it will show the affect on the cpu
cpu=`mpstat -o JSON 1 1 | jq '.sysstat.hosts[0].statistics[0]."cpu-load"[0].idle'`
# kills the loadtest process
pkill loadtest

#synthetic.dat is a file produced by the loadtest code
#it show how many transaction were complete when it runs 
#we used the grep command to find out if a process was running in week 8
#here im using it to see how many transaction were complete dung each loop
cnt=`grep -c "Transaction Complete " synthetic.dat`

#this outputs the Co, number of users and amount of cpu used 
#to output each on the same line in the results.dat each value was stored in a variable 
echo $cnt $i $cpu >> results.dat
#end of loop
done

