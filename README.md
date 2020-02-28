# openmediavault_zfs
 A easy way for snapshot and destroy function of zfs in openmediavault

一种简单地方式在openmediavault系统中应用zfs进行自动化快照和快照删除



# Usage

## Root
Get `root` power, which is commonly default in the `openmediavault` system. 获得root权限，一般是默认的。

 ```shell
root@openmediavault:~# 
 ```

## Installation
Copy the code and run in the shell. 复制下面的代码并且粘贴到shell，按Enter运行。

```bash
git clone https://github.com/huangwb8/openmediavault_zfs.git && \
chmod +777 ./openmediavault_zfs/openmediavault_zfs.sh && \
cp ./openmediavault_zfs/openmediavault_zfs.sh /sbin/ && \
echo "0 3 * * * root openmediavault_zfs.sh snapshot" >> /etc/crontab && \
echo "0 5 * * * root openmediavault_zfs.sh destroy" >> /etc/crontab
```
What the code doing is: 代码的含义是：
+ Git clone. 从github复制openmediavault_zfs仓库
+ Make the script executable. 让openmediavault_zfs.sh变成可执行文件
+ Make the script executable.将openmediavault_zfs.sh复制到/sbin/目录（这是环境路径，使用时可以直接引用）
+ 添加命令到crontab中以实现定时运行。

## Test
测试是否安装成功

```bash
openmediavault_zfs.sh test
```
If you can see something like 
```shell
-rwxrwxrwx
0 5 * * * root openmediavault_zfs.sh destroy
0 7 1 * * root reboot
```
in the shell, that means success!  奥力给！

## Meaning

It means that the system would create a snapshot in 3:00.am and destroy a 7-day-before one in 5:00 a.m.. 这意味着系统在每天早上3点钟创建一个新的快照，并在早上5点钟删除一个7天前的快照。

If you want to customize the time, first you have to command some knowledge about `cro`, which you can learn [here](https://www.runoob.com/linux/linux-comm-crontab.html). 如果你想自定义时间，你需要了解一下linux的cron相关知识。详见[这里](https://www.runoob.com/linux/linux-comm-crontab.html)。

## Note 注意事项



