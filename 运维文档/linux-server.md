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

