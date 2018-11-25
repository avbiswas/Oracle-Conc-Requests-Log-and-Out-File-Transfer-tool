#!/bin/sh
export PROD_LOG_TOP=/u01/appamdev00/PROD_LOGS
export MAX_PENDING_REQUESTS=5
if [ -e $PROD_LOG_TOP/.request_temp_ppost ]; then
CURRENT_BATCH_SIZE=`wc -l < $PROD_LOG_TOP/.request_temp_ppost`
else
CURRENT_BATCH_SIZE=0
fi
requests_to_copy=`expr $MAX_PENDING_REQUESTS - $CURRENT_BATCH_SIZE`
if [ $CURRENT_BATCH_SIZE -ge $MAX_PENDING_REQUESTS ]; then
echo "Loaded"
exit
fi
if [ -e /u01/appamdev00/PROD_LOGS/.sending ]; then
echo "Busy"
exit
fi
start_line_number=`grep -vn 'COPIED' $PROD_LOG_TOP/request_files.txt|head -1|awk -F ':' '{print $1}'`
end_line_number=$(($start_line_number+$requests_to_copy-1))
echo $start_line_number
echo $end_line_number
grep -v "COPIED"  $PROD_LOG_TOP/request_files.txt|head -$MAX_PENDING_REQUESTS >> $PROD_LOG_TOP/.request_temp_ppost
sed -i "$start_line_number,$end_line_number s/$/ COPIED/" $PROD_LOG_TOP/request_files.txt
