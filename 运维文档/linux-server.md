[toc]

# Ansible



## 常用命令



```shell
ansible <groupName> --list
ansible-doc -s <modle>
ansible <groupName> -m command -a 'yum update -y'

# playbook:  ansible-playbook <filename.yml> ...[options]
ansible-playbook <filename.yml> --check # 只检测，不执行
ansible-playbook <filename.yml>
# 定义变量vars的值为xxx
ansible-playbook -e 'vars=xxx' a.yml
## options选项
--list-hosts      # 列出运行任务的主机
--limit <主机列表> # 只针对主机列表中的主机执行
-v #显示过程 -vv -vvv更详细
```



## 常用模块(ansible-playbook)

- copy
- script: `ansible all - script -a '/root/a.sh'` 执行脚本
- unarchive
- file
- template



循环语法：

```j2
{% for port in ports %}
server {
    listen {{ port }}
}
{% endfor %}

```



# Docker



## 安装后操作



```shell
# 创建一个docker Group 
sudo groupadd docker 
# 添加用户到docker用户组 
sudo usermod -aG docker wuyang

# centos8安装冲突问题
yum erase podman buildah -y

# 设置开机自启
systemctl enable docker

# 镜像加速
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://12zgkuiq.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker

#显示所有的容器，过滤出Exited状态的容器，取出这些容器的ID
sudo docker ps -a|grep Exited|awk '{print $1}'
# 停止全部容器
docker stop $(docker ps -a -q)
# 删除全部容器
docker rm $(docker ps -a -q)
# 删除孤立的容器
sudo docker container prune
```

