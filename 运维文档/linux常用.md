[toc]

# 1. Linux常用命令

## 1.1. centos7

### 防火墙相关操作

```shell
# 查看防火墙规则
sudo firewall-cmd --list-all
# firewalld.service服务开启、重启、关闭
service firewalld start/restart/stop
# 查询端口是否开放
firewall-cmd --query-port=8080/tcp
# 开放80端口
firewall-cmd --permanent --add-port=80/tcp
# 移除端口
firewall-cmd --permanent --remove-port=8080/tcp
# 重启防火墙
firewall-cmd --reload
# 参数解释
firewall-cmd firewall工具命令
--permanent 表示设置为持久
--add-port 添加端口
```

### 静态ip地址设置

修改配置文件，指定宿主机的ip、默认网关、子网掩码、DNS

**centos7**
```shell
sudo vim /etc/sysconfig/network-scripts/ifcfg-ens33
# dhcp -> static
BOOTPROTO="static"
IPADDR="192.168.1.200"
NETMASK="255.255.255.0"
GATEWAY="192.168.1.1"
DNS1="8.8.8.8"

sudo service network restart
```

**ubuntu**

```shell
sudo vim /etc/netplan/*.yaml
# 更新yaml文件为下面的值

# 更新yaml文件后执行
sudo netplan apply

# 最后修改dns
sudo vim /etc/systemd/resolved.conf

sudo systemctl restart systemd-resolved.service
```

### 用户管理

新增用户：`adduser [用户名]`
修改用户密码：`passwd [用户名]`
赋予用户sudo命令权限：
1. 添加sudoers文件可写权限：`chmod -v u+w /etc/sudoers`
2. 编辑sudoers文件
```sh
root    ALL=(ALL)       ALL
xxxx    ALL=(ALL)       ALL
# 如果用户输入sudo不需要密码，则   xxxx  ALL=(ALL)       NOPASSWD:ALL
```
3. 收回sudoers写权限：`chmod -v u-w /etc/sudoers`
4. 切换用户：`su xxx`

### 基础环境（java,maven,git）

**/etc/profile**

```sh
export JAVA_HOME=/opt/jdk1.8.0_231
export MAVEN_HOME=/opt/apache-maven-3.6.3
export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$MAVEN_HOME/bin:$JAVA_HOME/bin:$PATH
```

### rpm软件安装命令

- 数据库（公共）： /var/lib/rpm 程序包名称及版本，依赖关系，功能说名，包安装后生成的各文件路径及校验码信息

#### 语法

- 语法：`rpm (选项) (参数)`
- 常用：`rpm -ivh xxxxxx.rpm` , -i install, -v verbose冗余日志，-h 以#显示程序包管理执行进度
- `-i` 显示套件相关信息，`-v` 显示指令执行过程
- 查询是否已安装某组件：`rpm -qa | grep xxx`
- `rpm -ql <appName>` 查询包安装详细文件路径
- 卸载：`rpm -e <appName>`
- 查询包信息：`rpm -qi <appName>`

## 1.3. 通用命令

### 常用

- 软连接：`ln -s <source> <target>`
- 动态显示Log：`tail -f /xxx/xxx.log`
- 查看进程：`ps -ef|grep xxxx`
- 查看磁盘空间：`df -h`
- 查看负载： `free -m`
- make >& LOG_make &
- make install >& LOG_install &
- scp:`scp source username@ip:target` 拷贝文件夹 `scp -r source username@ip:target`
- ssh免密设置：`ssh-keygen -t rsa` 和`ssh-copy-id root@主机名` 
- 动态杀进程：`ps -ef | grep $name | grep -v grep | awk '{print $2}' | xargs kill -9`
- 查看当前文件夹总大小：`du -sh`
- 压缩文件：`tar czvf filename.tar dirname`
- 修改hostname: `hostnamectl set-hostname <new name>`
- 服务开机自启：`systemctl <disable/enable> [service]`

### 查询操作

- 查询日志：`grep "" catalina.out | grep --color -C10 ""`
- 查询进程端口：`netstat -unltp|grep fdfs`

### 同步时间

```shell
yum -y install ntp
ntpdate -u ntp.api.bz

sudo tzconfig
```

**ubuntu**
```shell
dpkg-reconfigure tzdata
```

### 关机/重启

```shell
sudo shutdown -h now
sudo init 6
```

### ssh免密配置

基于开源OpenSSH实现

```sh
# 生成sshkey
ssh-keygen -t rsa -C "uye8831@dingtalk.com"

# 免密登录，秘钥copy
ssh-copy-id <ip addr>
```

### 挂载mount命令

`mount [-t vfstype] [-o options] device dir`
`umount device`

- `-t vfstype`  文件系统类型，linux会自动选择正确的类型
- `-o option`  主要用来描述设备或档案的挂接方式，常用参数有：
    - `loop` 用来把一个文件当成硬盘分区挂接
    - `ro` 只读方式挂接
    - `rw` 读写方式挂接
- `device` 需要挂接的设备
- `dir` 设备在系统上的挂接点

### kvm常用命令



```shell
# 虚拟机列表查询
virsh list --all
# --name      --disk  需要修改
virt-install  --virt-type kvm \
 --os-type=linux \
 --os-variant=rhel7 \
 --name test-node1  \
 --vcpus sockets=1,cores=4,threads=2  \
 --ram 8192 \
 --cdrom /home/iso/CentOS-7-x86_64-DVD-2003.iso \
 --disk path=/home/images/test-node1.qcow2,size=250 \
 --accelerate \
 --network bridge=kbenp5s0   \
 --connect=qemu:///system \
 --graphics  vnc,password=zyzh2018,port=5950,listen=0.0.0.0 \
 --noautoconsole
 
# 创建快照
virsh snapshot-create-as <kvm-name> <kvm-snapshot-name>
# 查看指定虚拟机快照
virsh snapshot-list <kvm-name>
# 查看虚拟机快照文件位置
ll -h /var/lib/libvirt/qemu/snapshot/kvm107/
# 恢复虚拟机快照
virsh snapshot-revert <kvm-name> <kvm-snapshot-name>
# 删除执行虚拟机快照
virsh snapshot-delete <kvm-name> <kvm-snapshot-name>

## 修改虚拟机内存
virsh shutdown <kvm-name>
virsh setmaxmem <kvm-name> <kb>
virsh start <kvm-name>
virsh setmem <kvm-name> <kb>
```





## Nginx

### nginx安装

常用安装路径`/usr/local/nginx`
```shell
yum install -y pcre pcre-devel zlib zlib-devel openssl openssl-devel zlib zlib-devel openssl openssl-devel

./configure
make
make install
```

### nginx卸载
```shell
sudo find / -name nginx*
sudo rm -rf file /xxx/xxx/nginx*
```



## 必备工具

### 文件上传

`yum -y install lrzsz`

