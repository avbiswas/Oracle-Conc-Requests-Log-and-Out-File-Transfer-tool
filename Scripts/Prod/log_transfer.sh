#!/bin/sh

export transfer_path=/home/applmgr/log_transfer

export APPLCSF_PPOST='/u01/ppost/apps/apps_st/appl/APPLCSF';
cd $transfer_path

if [ -e $transfer_path/.request_temp_ppost ]; then
        echo "Already Running"
        exit
fi

RUNNING=`ps -ef|grep '/home/applmgr/log_transfer/log_transfer.sh'|wc -l`

if [ $RUNNING -gt 4 ]; then
echo "Already running"
exit
fi

touch .sending

lftp -u aamdev00,IM1ck3y sftp://ald-kaleb.posten.no <<commands
cd /u01/appamdev00/PROD_LOGS
put .sending
get .request_temp_ppost
exit
commands



if [ -e  $transfer_path/.request_temp_ppost ]; then
requests=($(awk '/PPOST/ {print $1}' $transfer_path/.request_temp_ppost))
declare cmd=''
for request_id in ${requests[*]}
        do
               cmd="$cmd $APPLCSF_PPOST/log/l$request_id.req $APPLCSF_PPOST/out/o$request_id.out"
        done
cp $cmd $transfer_path/PPOST/
echo $cmd
touch $transfer_path/.file_transfer_successful_ppost

lftp -u aamdev00,IM1ck3y sftp://ald-kaleb.posten.no <<commands
cd /u01/appamdev00/PPOST_LOGS/
mput ./PPOST/*
put .file_transfer_successful_ppost
rm /u01/appamdev00/PROD_LOGS/.request_temp_ppost
exit
commands

rm $transfer_path/.request_temp_ppost
rm $transfer_path/PPOST/*

else
lftp -u aamdev00,IM1ck3y sftp://ald-kaleb.posten.no <<commands
rm /u01/appamdev00/PROD_LOGS/.sending
exit
commands



echo "No requests for PPOST"
fi


