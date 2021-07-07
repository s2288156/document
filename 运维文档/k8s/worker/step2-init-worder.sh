#!/bin/bash
# 只在 worker 节点执行
# 替换 x.x.x.x 为 master 节点的内网 IP
export MASTER_IP=192.168.2.132
# 替换 apiserver.demo 为初始化 master 节点时所使用的 APISERVER_NAME
export APISERVER_NAME=master.node1.com
echo "${MASTER_IP}    ${APISERVER_NAME}" >> /etc/hosts

# run command for masterNode:   kubeadm token create --print-join-command
# 替换为 master 节点上 kubeadm token create 命令的输出
kubeadm join master.node1.com:6443 --token f9jgr9.ackaglnx4ip5meku --discovery-token-ca-cert-hash sha256:139765aae4ac5250b36c6416fb2adab4e193f6e0ab4c01226d31e63b5e91433c

