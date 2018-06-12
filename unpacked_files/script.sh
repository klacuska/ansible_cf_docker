#!/bin/bash 


arg1="${1}"

mkdir /tmp/nmap 2>/dev/null
DIR=/tmp/nmap
NMAP=`which nmap`
date > /tmp/date
sed -i 's/ //g' /tmp/date


if [[ ${arg1} =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
	then
echo -e ""
echo -e ""
		echo scanning ${arg1}...
echo -e ""
		$NMAP ${arg1} > $DIR/nmap_outp
		grep -A 250 PORT $DIR/nmap_outp | grep -v Nmap > $DIR/nmap_outp_sorted-${arg1}-`cat /tmp/date`
elif [[ ${arg1} =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/[0-9]{1,2}$ ]]
	then
echo -e ""
echo -e ""
                echo scanning ${arg1}...
echo -e ""
                $NMAP ${arg1} > $DIR/nmap_outp
                grep -A 250 PORT $DIR/nmap_outp | grep -v Nmap > $DIR/nmap_outp_sorted-${arg1}-`cat /tmp/date`
	else
echo -e ""
		touch $DIR/nmap_outp_sorted-${arg1}-incorrect_format
		echo -e "\e[31mwrong format of IP or IP range, please provide it in correct format - e.g. 123.45.67.89 or 123.456.78.0/24 - examples"
fi
echo -e "\e[0m"



ls -al $DIR/nmap_outp_sorted-${arg1}*  | awk '{print $9}' > $DIR/nmap-files_for_diff-${arg1}
number_of_lines=`wc -l $DIR/nmap-files_for_diff-${arg1}  | awk '{print $1}'`
if [ $number_of_lines -gt 2 ]
	then
		tail -2 $DIR/nmap-files_for_diff-${arg1} > $DIR/nmap-files_for_diff_sorted-${arg1}
	        diff `head -1 $DIR/nmap-files_for_diff_sorted-${arg1}` `tail -1 $DIR/nmap-files_for_diff_sorted-${arg1}` > $DIR/${arg1}-diffed
		if [ -s $DIR/${arg1}-diffed ]
		        then
                		for i in `tail -1 $DIR/nmap-files_for_diff_sorted-${arg1}`
		                        do echo $i
                		done
	        else
        	        echo "Target - ${arg1} - No new records found in the last scan; data from last scan you can find in `tail -1 $DIR/nmap-files_for_diff_sorted-${arg1}`"
		fi
	
elif [ $number_of_lines -eq 2 ]
	then
		cat $DIR/nmap-files_for_diff-${arg1} > $DIR/nmap-files_for_diff_sorted-${arg1}
		diff `head -1 $DIR/nmap-files_for_diff_sorted-${arg1}` `tail -1 $DIR/nmap-files_for_diff_sorted-${arg1}` > $DIR/${arg1}-diffed
                if [ -s $DIR/${arg1}-diffed ]
                        then
                                for i in `tail -1 $DIR/nmap-files_for_diff_sorted-${arg1}`
                                        do echo $i
                                done
                else
                        echo "Target - ${arg1} - No new records found in the last scan; data from last scan you can find in `tail -1 $DIR/nmap-files_for_diff_sorted-${arg1}`"
                fi

elif [ $number_of_lines -eq 1 ]
	then
		cat $DIR/nmap_outp_sorted-${arg1}*
else
	echo -e "\e[31msomething went wrong, try to run it again"
fi
echo -e "\e[0m"
