#!/bin/sh

export transfer_path=/u03/erpprod/Monitoring_Scripts/log_transfer
export APPLCSF_ERPPROD='/u03/erpprod/apps/apps_st/appl/APPLCSF';
cd $transfer_path

if [  -e $transfer_path/.request_temp_erpprod ]; then
        echo "Already Running"
        exit
fi

RUNNING=`ps -ef|grep '/u03/erpprod/Monitoring_Scripts/log_transfer/log_transfer.sh'|wc -l`

if [ $RUNNING -gt 4 ]; then
echo "Already running!"
exit
fi

touch .sending_erpprod

lftp -u aerpdev,apperp00 sftp://ald-kaleb.posten.no <<commands
cd /u01/apperpdev/PROD_LOGS
put .sending_erpprod
get .request_temp_erpprod
exit
commands

if [ -e  $transfer_path/.request_temp_erpprod ]; then
requests=($(awk '/ERPPROD/ {print $1}' $transfer_path/.request_temp_erpprod))
declare cmd=''
for request_id in ${requests[*]}
        do
               cmd="$cmd $APPLCSF_ERPPROD/log/l$request_id.req $APPLCSF_ERPPROD/out/o$request_id.out"
        done

cp $cmd $transfer_path/ERPPROD/
echo $cmd
touch $transfer_path/.file_transfer_successful_ERPPROD

lftp -u aerpdev,apperp00 sftp://ald-kaleb.posten.no <<commands
cd /u01/apperpdev/ERPPROD_LOGS/
rm /u01/apperpdev/PROD_LOGS/.sending_erpprod
put .file_transfer_successful_ERPPROD
rm /u01/apperpdev/PROD_LOGS/.request_temp_erpprod
mput ./ERPPROD/*

exit
commands

rm $transfer_path/.request_temp_erpprod
rm $transfer_path/ERPPROD/*

else
lftp -u aerpdev,apperp00 sftp://ald-kaleb.posten.no <<commands
rm /u01/apperpdev/PROD_LOGS/.sending_erpprod
exit
commands

echo "No requests for ERPPROD"
fi

