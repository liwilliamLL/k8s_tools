#!/bin/bash
# Script For Quick Pull K8S Docker Images
# by li,william

iptables -F  #清除防火墙规则
systemctl stop firewalld  #关闭防火墙
setenforce 0   #关闭selinux


echo "1">/proc/sys/net/bridge/bridge-nf-call-iptables
echo "1">/proc/sys/net/bridge/bridge-nf-call-ip6tables

KUBE_VERSION=v1.22.2    #kubeadm的版本 
PAUSE_VERSION=3.4.1     #暂停容器的镜像版本
CORE_DNS_VERSION=v1.8.0 #coreDns容器的镜像版本
ETCD_VERSION=3.4.13-0   #ETCD的版本


#k8s基础镜像
imagesName=("kube-apiserver" "kube-proxy" "kube-controller-manager" "kube-scheduler")
for i in "${!imagesName[@]}";
do
  docker pull juziwudi/${imagesName[$i]}:$KUBE_VERSION
  docker tag  juziwudi/${imagesName[$i]}:$KUBE_VERSION k8s.gcr.io/${imagesName[$i]}:$KUBE_VERSION
  docker rmi juziwudi/${imagesName[$i]}:$KUBE_VERSION
done

#k8s DNS镜像
docker pull juziwudi/coredns:$CORE_DNS_VERSION 
docker tag  juziwudi/coredns:$CORE_DNS_VERSION k8s.gcr.io/coredns/coredns:$CORE_DNS_VERSION
docker rmi juziwudi/coredns:$CORE_DNS_VERSION

#k8s 暂停容器镜像
docker pull juziwudi/pause:$PAUSE_VERSION
docker tag  juziwudi/pause:$PAUSE_VERSION k8s.gcr.io/pause:$PAUSE_VERSION
docker rmi juziwudi/pause:$PAUSE_VERSION

#k8s ETCD容器镜像
docker pull juziwudi/etcd:$ETCD_VERSION
docker tag k8s.gcr.io/etcd:$ETCD_VERSION juziwudi/etcd:$ETCD_VERSION
docker rmi juziwudi/etcd:$ETCD_VERSION