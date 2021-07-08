[toc]

# 1. Ansible

## 1.1 常用命令

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

## 1.2 常用模块(ansible-playbook)

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

# 2. Docker

## 2.1 安装后操作


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

## 2.2 docker常用命令



```shell
docker build -t friendlyhello .  			# 通过当前文件夹的Dockerfile文件构建镜像
docker run -p 4000:80 friendlyhello  		# 运行镜像，并将4000端口映射到容器的80端口上
docker run -d -p 4000:80 friendlyhello      # Same thing, but in detached mode
docker container ls                         # 所有运行中的容器列表
docker container ls -a             			# 所有容器列表，包括没有运行的
docker container stop <hash>           		# 正常关闭指定容器
docker container kill <hash>         		# 强制关闭指定容器
docker container rm <hash>        			# 从设备上删除指定容器
docker container rm $(docker container ls -a -q)         # 删除所有容器
docker container prune						# 删除孤立的容器
docker image ls -a                          # 本机所有镜像列表
docker image rm <image id>            		# 删除本机指定镜像
docker image rm $(docker image ls -a -q)   	# 删除本机所有镜像
docker login             					# 在这个命令窗口登录Docker凭证
docker tag <image> username/repository:tag  # 为要上传到registry的镜像创建tag
docker push username/repository:tag         # 将镜像推送到registry
docker run username/repository:tag          # 从registry运行镜像
docker exec -it <containerId> /bin/bash		# 进入容器
# local copy to container
docker cp [OPTIONS] CONTAINER:SRC_PATH    DEST_PATH
# container to local
docker cp [OPTIONS] SRC_PATH    CONTAINER:DEST_PATH
```



## 2.3 docker-compose常用命令



```shell
```

