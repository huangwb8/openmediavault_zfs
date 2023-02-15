# openmediavault_zfs
 Automate snapshot and destroy for ZFS pools in openmediavault (OMV) NAS system

在openmediavault中对ZFS文件系统进行自动化备份和删除快照的操作

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
chmod +770 $(pwd)/openmediavault_zfs/openmediavault_zfs.sh && \
ln -s $(pwd)/openmediavault_zfs/openmediavault_zfs.sh /sbin/openmediavault_zfs.sh && \
echo -e "\n# Create a snapshot in 3:00 am\n0 3 * * * root openmediavault_zfs.sh snapshot >/dev/null 2>&1" >> /etc/crontab && \
echo -e "\n# Destroy a snapshot in 5:00 am\n0 5 * * * root openmediavault_zfs.sh destroy 15 >/dev/null 2>&1" >> /etc/crontab
```
What the code doing is: 代码的含义是：
+ Git clone. 从github复制openmediavault_zfs仓库
+ Make the script executable. 让openmediavault_zfs.sh变成可执行文件
+ Add the script into the system environment dir. 将openmediavault_zfs.sh复制到/sbin/目录（这是环境路径，使用时可以直接引用）
+ Add 2 cron record into /etc/crontab. 添加2个命令到crontab中以实现定时运行。

The massage would be : 代码运行结果是：

```shell
Cloning into 'openmediavault_zfs'...
remote: Enumerating objects: 37, done.
remote: Counting objects: 100% (37/37), done.
remote: Compressing objects: 100% (25/25), done.
remote: Total 37 (delta 17), reused 32 (delta 12), pack-reused 0
Unpacking objects: 100% (37/37), done.
```

## Test
Test whether the code works. 测试是否安装成功

```bash
openmediavault_zfs.sh test
```
If you can see something like: 如果可以看到如下类似内容：
```shell
Pool: XXX
-rwxrwxrwx
0 3 * * * root openmediavault_zfs.sh snapshot >/dev/null 2>&1
0 5 * * * root openmediavault_zfs.sh destroy 15 >/dev/null 2>&1
...
```
in the shell, that means success!  搞定！

## Note

+ It means that the system would create a snapshot in 3:00.am and destroy a 15-day-before one in 5:00 a.m. 这意味着系统在每天早上3点钟创建一个新的快照，并在早上5点钟删除一个15天前的快照。

+ If you want to customize the time, first you have to command some knowledge about `cro`, which you can learn [here](https://www.runoob.com/linux/linux-comm-crontab.html). 如果你想自定义时间，你需要了解一下linux的cron相关知识。详见[这里](https://www.runoob.com/linux/linux-comm-crontab.html)。

+ If you run times of the fore code, you had better to check via `vi /etc/crontab` to avoid repeated records in `Crontab`. 如果你已经运行过此代码一次，`openmediavault_zfs`就已经在本地，此时只要运行下方代码即可添加cron记录。多次运行代码时，建议通过`vi /etc/crontab`等方法检查或修改，以免产生重复记录。

+ More examples. 更多示例：

  ```shell
  # vi /etc/crontab
  0 5 * * * root openmediavault_zfs.sh destroy 30 >/dev/null 2>&1# destroy 30-day-ago snapshot everyday in 5:00 a.m.
  ```

+ 如果创建了snapshot，在删除文件后，zfs文件系统的空间很可能不会增加。你还要要删除该文件出现之后的所有snapshot才可以释放空间。简单粗暴的方法是，如果你确定可以删除所有snapshot，则：

  ```bash
  su
  zfs list -H -o name -t snapshot | xargs -n1 zfs destroy -R
  ```

## Log

+ **2023-02-15**：Use `echo -e` to add more humanized cron events.
+ **2022-12-13**: Add `>/dev/null 2>&1` at the end of each command of `cron` (strongly recommended!), which doesn't trigger the mail notification of openmediavault.
+ **2022-01-13**: Repair generalize pool names to any string instead of `nas` only.

# More

Welcome to my blog: [https://blognas.hwb0307.com](https://blognas.hwb0307.com)

欢迎来我的博客 [https://blognas.hwb0307.com](https://blognas.hwb0307.com)，有更多Linux/docker的实用教程等着你喔！
