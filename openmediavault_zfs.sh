#!/usr/bin/bash

# Reference
# cron: https://www.runoob.com/linux/linux-comm-crontab.html

# log
## 2022-01-13: 
## 1. generalize pool names to any string instead of `nas` only.

# Introduction
## Create or destory snapshots of ZFS pools in Openmediavault

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
	
	if [ 1 -ge 2 ]; then
	echo 3
	fi
	
}


# Parameter
type=$1 # 执行类型: snapshot ; destroy; test
every=$2 # 每多少天进行快照删除。

# Programe

## check the name of pools
pool=(`/sbin/zpool list | cut -d' ' -f1`)
num=${#pool[@]}

## Running programe
if [ $num -ge 2 ]; then
	for ((i=2;i<=$num;i++));
	do
	
	# Get one pool
	p=`echo ${pool}|cut -d' ' -f${i}`
	
	# Snapshot
	if [ ${type} == "snapshot" ]; then 
	/sbin/zfs snapshot -r ${p}@AutoD-`date +"%F"`
	elif [ ${type} == "destroy" ]; then
		dataset=`/sbin/zfs list -t snapshot -o name | /bin/grep ${p}@AutoD- | /usr/bin/sort -r | /usr/bin/tail -n +${every}`
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
	done
fi
