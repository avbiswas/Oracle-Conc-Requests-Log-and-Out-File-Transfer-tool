#!/bin/sh
 cd /u01/appamdev00/PROD_LOGS
export PENDING_1=`grep -i 'PPOST' request_files.txt|grep -v 'COPIED'|wc -l`


if [ -e .request_temp_ppost ]; then
export PENDING_2=`wc -l < .request_temp_ppost`
else
PENDING_2=0
fi
export TOTAL_PENDING=$(($PENDING_1 + $PENDING_2))
export MAX_PENDING=25
export ALLOWED_REQUESTS=$(($MAX_PENDING - $TOTAL_PENDING))

echo "Maximum requests allowed now:"  $ALLOWED_REQUESTS
echo "Enter Request ID from PPOST. If you are entering multiple request IDs, please seperate them with a space."
read -a requests;
total_requests=${#requests[@]}
echo $total_requests
if [ $total_requests -gt $ALLOWED_REQUESTS ]; then
echo "Max limit exceeded. Please re-enter with correct number of requests."
exit
else
for request_id in ${requests[*]}
do
        sed -i '$a\'"$request_id PPOST"'' /u01/appamdev00/PROD_LOGS/request_files.txt
done
echo "Thank you. Note that 5 log-out pairs will get transferred from Production every 5 minutes on a first-come-first-serve basis. Files will be placed in location:"
echo "/u01/appamdev00/PPOST_LOGS";
fi
