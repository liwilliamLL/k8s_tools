#!/bin/bash
# Script For Quick Pull K8S Docker Images
# Quick Create K8S Docker Images Proxy
# by li,william


KUBE_VERSION=v1.22.2    #kubeadm的版本 
PAUSE_VERSION=3.4.1     #暂停容器的镜像版本
CORE_DNS_VERSION=v1.8.0 #coreDns容器的镜像版本
ETCD_VERSION=3.4.13-0   #ETCD的版本


# k8s.gcr.io/kube-apiserver            v1.21.0    4d217480042e   2 weeks ago     126MB
# k8s.gcr.io/kube-proxy                v1.21.0    38ddd85fe90e   2 weeks ago     122MB
# k8s.gcr.io/kube-controller-manager   v1.21.0    09708983cc37   2 weeks ago     120MB
# k8s.gcr.io/kube-scheduler            v1.21.0    62ad3129eca8   2 weeks ago     50.6MB
# k8s.gcr.io/pause                     3.4.1      0f8457a4c2ec   3 months ago    683kB
# k8s.gcr.io/coredns/coredns           v1.8.0     296a6d5035e2   6 months ago    42.5MB
# k8s.gcr.io/etcd                      3.4.13-0   0369cf4303ff   8 months ago    253MB

#k8s基础镜像
imagesName=("kube-apiserver" "kube-proxy" "kube-controller-manager" "kube-scheduler")
for i in "${!imagesName[@]}";
do
  docker pull k8s.gcr.io/${imagesName[$i]}:$KUBE_VERSION
  docker tag k8s.gcr.io/${imagesName[$i]}:$KUBE_VERSION juziwudi/${imagesName[$i]}:$KUBE_VERSION
  docker push juziwudi/${imagesName[$i]}:$KUBE_VERSION
  docker rmi juziwudi/${imagesName[$i]}:$KUBE_VERSION
done

#k8s DNS镜像
docker pull k8s.gcr.io/coredns/coredns:$CORE_DNS_VERSION
docker tag k8s.gcr.io/coredns/coredns:$CORE_DNS_VERSION juziwudi/coredns:$CORE_DNS_VERSION
docker push juziwudi/coredns:$CORE_DNS_VERSION

#k8s 暂停容器镜像
docker pull k8s.gcr.io/pause:$PAUSE_VERSION
docker tag k8s.gcr.io/pause:$PAUSE_VERSION juziwudi/pause:$PAUSE_VERSION
docker push juziwudi/pause:$PAUSE_VERSION

#k8s ETCD容器镜像
docker pull k8s.gcr.io/etcd:$ETCD_VERSION
docker tag k8s.gcr.io/etcd:$ETCD_VERSION juziwudi/etcd:$ETCD_VERSION
docker push juziwudi/etcd:$ETCD_VERSION