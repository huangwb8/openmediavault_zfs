#! /usr/bin/bash

# Reference
# cron: https://www.runoob.com/linux/linux-comm-crontab.html

# Usage

# chmod +777 ./openmediavault_zfs.sh && mv ./openmediavault_zfs.sh /sbin

# 1.Basic usage
# * 3 * * * /usr/bin/bash openmediavault_zfs.sh snapshot
# * 5 * * * /usr/bin/bash openmediavault_zfs.sh destroy

# 2.Cron
# echo "* 3 * * * root openmediavault_zfs.sh snapshot" >> /etc/crontab
# echo "* 5 * * * root openmediavault_zfs.sh destroy" >> /etc/crontab

# Parameter
type=$1 # 执行类型: snapshot ; destroy
every=7 # 每多少天进行快照删除。可自定义

# Create a snapshot
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
else 
	echo "Please input right type: One of 'snapshot' and 'destory'. "
fi	
# End
