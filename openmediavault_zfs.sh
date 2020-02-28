#!/usr/bin/bash

# Reference
# cron: https://www.runoob.com/linux/linux-comm-crontab.html

# Usage
USAGE_NOTRUN()
{
	chmod +777 ./openmediavault_zfs.sh && cp ./openmediavault_zfs.sh /sbin

	# 1.Basic usage
	bash openmediavault_zfs.sh snapshot
	bash openmediavault_zfs.sh destroy
	bash openmediavault_zfs.sh test

	# 2.Cron
	echo "0 3 * * * root openmediavault_zfs.sh snapshot" >> /etc/crontab
	echo "0 5 * * * root openmediavault_zfs.sh destroy" >> /etc/crontab
	
	# 3.Check crontab
	vim /etc/crontab
}


# Parameter
type=$1 # 执行类型: snapshot ; destroy; test
every=$2 # 每多少天进行快照删除。

# Programe
if [ ${type} == "snapshot" ]; then 
	/sbin/zfs snapshot -r nas@AutoD-`date +"%F"`
elif [ ${type} == "destroy" ]; then
	dataset=`/sbin/zfs list -t snapshot -o name | /bin/grep nas@AutoD- | /usr/bin/sort -r | /usr/bin/tail -n +${every}`
	if [ -z ${dataset} ]; then
		echo "no datasets available"
	else 
		echo "destroy ${dataset}"
		/sbin/zfs destroy -r ${dataset}
	fi
elif [ ${type} == "test" ]; then
	ls /sbin/openmediavault_zfs.sh -hl | cut -d' ' -f1 && cat /etc/crontab | grep openmediavault_zfs.sh
else 
	echo "Please input right type: One of 'snapshot', 'destory' or 'test'."
fi	
# End