# Aleksey Stepanenko

Table of Contents
=================

   * [Aleksey Stepanenko](#aleksey-stepanenko)
   * [Table of Contents](#table-of-contents)
   * [HW 29](#hw-29)
      * [Kubernetes-2](#kubernetes-2)
      * [Google K8s Engine](#google-k8s-engine)
   * [HW 28](#hw-28)
      * [Kubernetes-1 The Hard Way](#kubernetes-1-the-hard-way)
         * [1. Prerequisites](#1-prerequisites)
         * [2. cfssl, cfssljson, and kubectl.](#2-cfssl-cfssljson-and-kubectl)
         * [3. Сеть, Firewall](#3-Сеть-firewall)
         * [7. etcd](#7-etcd)
         * [8. LB](#8-lb)
         * [9.](#9)
         * [10.](#10)
         * [11.](#11)
         * [12.](#12)
         * [13. Smoke Test](#13-smoke-test)
      * [Основное задание](#Основное-задание)
   * [HW 27 Swarm-1](#hw-27-swarm-1)
   * [HW 25 Logging-1](#hw-25-logging-1)
      * [Основное задание](#Основное-задание-1)
   * [HW 23 Monitoring-2](#hw-23-monitoring-2)
      * [Основное задание](#Основное-задание-2)
   * [HW 21 Monitoring-1](#hw-21-monitoring-1)
      * [Основное задание](#Основное-задание-3)
      * [ДЗ * (mongo exporter)](#ДЗ--mongo-exporter)
      * [ДЗ ** (Blackbox)](#ДЗ--blackbox)
      * [ДЗ *** (Makefile)](#ДЗ--makefile)
   * [HW 20 Docker-7](#hw-20-docker-7)
      * [Основное задание](#Основное-задание-4)
      * [ДЗ * (Авторазварачивание environment)](#ДЗ--Авторазварачивание-environment)
      * [ДЗ ** (Деплой приложения)](#ДЗ--Деплой-приложения)
   * [HW 19 Docker-6](#hw-19-docker-6)
      * [Основное задание](#Основное-задание-5)
      * [ДЗ * (Авто регистрация Runner)](#ДЗ--Авто-регистрация-runner)
      * [ДЗ ** (Нотификация в слак)](#ДЗ--Нотификация-в-слак)
   * [HW 17 Docker-4](#hw-17-docker-4)
      * [Основное задание](#Основное-задание-6)
      * [ДЗ ** (Bridge network driver)](#ДЗ--bridge-network-driver)
      * [HW 17 ДЗ***](#hw-17-ДЗ)
      * [17 ДЗ**** (Override)](#17-ДЗ-override)
   * [HW 16 Dockder-3](#hw-16-dockder-3)
      * [Основное задание](#Основное-задание-7)
      * [ДЗ * (Сетевые алиасы)](#ДЗ--Сетевые-алиасы)
      * [ДЗ ** (Сборка с alpine)](#ДЗ--Сборка-с-alpine)
      * [ДЗ *** (Ужать образ)](#ДЗ--Ужать-образ)
   * [HW 15 Docker-2](#hw-15-docker-2)
      * [Основное задание](#Основное-задание-8)
      * [ДЗ *](#ДЗ-)
   * [HW 14 Docker-1](#hw-14-docker-1)
      * [Основное задание](#Основное-задание-9)
      * [ДЗ *](#ДЗ--1)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)

# HW 30

## Kubernetes-3

```bash
$ kubectl get services -n dev
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
comment      ClusterIP   10.39.250.241   <none>        9292/TCP         2d
comment-db   ClusterIP   10.39.251.46    <none>        27017/TCP        2d
mongodb      ClusterIP   10.39.240.106   <none>        27017/TCP        2d
post         ClusterIP   10.39.250.194   <none>        5000/TCP         2d
post-db      ClusterIP   10.39.255.19    <none>        27017/TCP        2d
ui           NodePort    10.39.244.14    <none>        9292:32093/TCP   2d
```

```bash
f3ex at MacBook-Pro-f3ex in ~/otus/DevOps/f4rx_microservices/kubernetes (kubernetes-3●)
$ kubectl get pods -n dev
NAME                       READY     STATUS    RESTARTS   AGE
comment-6d68f4f6d5-2mhtp   1/1       Running   0          2h
comment-6d68f4f6d5-5n4kx   1/1       Running   0          8h
comment-6d68f4f6d5-8klkz   1/1       Running   0          5h
mongo-77dcb74cd5-d5js2     1/1       Running   0          2d
post-5bc4b449f-5zgs2       1/1       Running   0          2d
post-5bc4b449f-6s74p       1/1       Running   0          2d
post-5bc4b449f-xh2tj       1/1       Running   0          2d
ui-6b4d654587-476qz        1/1       Running   0          2d
ui-6b4d654587-52k6v        1/1       Running   0          2d
ui-6b4d654587-nd6mm        1/1       Running   0          2d

f3ex at MacBook-Pro-f3ex in ~/otus/DevOps/f4rx_microservices/kubernetes (kubernetes-3●)
$ kubectl exec -ti -n dev ui-6b4d654587-nd6mm ping comment
ping: bad address 'comment'
command terminated with exit code 1

f3ex at MacBook-Pro-f3ex in ~/otus/DevOps/f4rx_microservices/kubernetes (kubernetes-3●)
$ kubectl scale deployment --replicas 1 -n kube-system kube-dnsautoscaler
Error from server (NotFound): deployments.extensions "kube-dnsautoscaler" not found

f3ex at MacBook-Pro-f3ex in ~/otus/DevOps/f4rx_microservices/kubernetes (kubernetes-3●)
$ kubectl scale deployment --replicas 1 -n kube-system kube-dns-autoscaler
deployment "kube-dns-autoscaler" scaled

f3ex at MacBook-Pro-f3ex in ~/otus/DevOps/f4rx_microservices/kubernetes (kubernetes-3●)
$ kubectl exec -ti -n dev ui-6b4d654587-nd6mm ping comment
ping: bad address 'comment'
command terminated with exit code 1

f3ex at MacBook-Pro-f3ex in ~/otus/DevOps/f4rx_microservices/kubernetes (kubernetes-3●)
$ kubectl exec -ti -n dev ui-6b4d654587-nd6mm ping comment
PING comment (10.39.250.241): 56 data bytes


^C
--- comment ping statistics ---
21 packets transmitted, 0 packets received, 100% packet loss
command terminated with exit code 1
```

Приложение открывается по адресу http://35.205.164.177:32093/



# HW 29

## Kubernetes-2

```bash
#Проверяю версию
$ kubectl version

Client Version: version.Info{Major:"1", Minor:"9", GitVersion:"v1.9.0", GitCommit:"925c127ec6b946659ad0fd596fa959be43f0cc05", GitTreeState:"clean", BuildDate:"2017-12-15T21:07:38Z", GoVersion:"go1.9.2", Compiler:"gc", Platform:"darwin/amd64"}
```
Установка Minukube
```bash
brew cask install minikube 
```

Запускаем миникуб
```bash
$ minikube start
Starting local Kubernetes v1.9.4 cluster...
Starting VM...
Downloading Minikube ISO
 142.22 MB / 142.22 MB [============================================] 100.00% 0s
Getting VM IP address...
Moving files into cluster...
Downloading localkube binary
 163.02 MB / 163.02 MB [============================================] 100.00% 0s
 0 B / 65 B [----------------------------------------------------------]   0.00%
 65 B / 65 B [======================================================] 100.00% 0sSetting up certs...
Connecting to cluster...
Setting up kubeconfig...
Starting cluster components...
Kubectl is now configured to use the cluster.
Loading cached images from config file.
```
Наш Minikube-кластер развернут. При этом автоматически был настроен конфиг kubectl.
```bash
$ kubectl get nodes
NAME       STATUS    ROLES     AGE       VERSION
minikube   Ready     <none>    4m        v1.9.4
```

```bash
$  kubectl config get-contexts
CURRENT   NAME                      CLUSTER                   AUTHINFO   NAMESPACE
          kubernetes-the-hard-way   kubernetes-the-hard-way   admin
*         minikube                  minikube                  minikube

$ kubectl config get-contexts
CURRENT   NAME                      CLUSTER                   AUTHINFO   NAMESPACE
          kubernetes-the-hard-way   kubernetes-the-hard-way   admin
*         minikube                  minikube                  minikube
```

```bash
$ kubectl apply -f ui-deployment.yml
deployment "ui" created

$ kubectl get deployment
NAME      DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
ui        3         3         3            0           9s
```

```bash
$ kubectl get pods --selector component=ui
NAME                 READY     STATUS    RESTARTS   AGE
ui-55d99c987-2qzfq   1/1       Running   0          30m
ui-55d99c987-4jp5t   1/1       Running   0          30m
ui-55d99c987-m2mvp   1/1       Running   0          30m

$ kubectl port-forward ui-55d99c987-2qzfq 8080:9292
Forwarding from 127.0.0.1:8080 -> 9292

open http://127.0.0.1:8080/
```

```bash
$ minikube service list
|-------------|----------------------|-----------------------------|
|  NAMESPACE  |         NAME         |             URL             |
|-------------|----------------------|-----------------------------|
| default     | comment              | No node port                |
| default     | comment-db           | No node port                |
| default     | kubernetes           | No node port                |
| default     | mongodb              | No node port                |
| default     | post                 | No node port                |
| default     | post-db              | No node port                |
| default     | ui                   | http://192.168.99.101:32092 |
| kube-system | kube-dns             | No node port                |
| kube-system | kubernetes-dashboard | http://192.168.99.101:30000 |
|-------------|----------------------|-----------------------------|
```

## Google K8s Engine

![K8s engine-1](images/hw29_k8s-2-1.png?raw=true "hw29_k8s-2-1.png")
![K8s engine-2](images/hw29_k8s-2-2.png?raw=true "hw29_k8s-2-2.png")
![K8s engine-3](images/hw29_k8s-2-3.png?raw=true "hw29_k8s-2-3.png")


# HW 28

## Kubernetes-1 The Hard Way

Развернуть лабу согласно с гайдом https://github.com/kelseyhightower/kubernetes-the-hard-way/

### 1. Prerequisites
Проверяем, что установлен gcloud и дефолтные зоны
```bash
$ gcloud config get-value compute/region
europe-west1

$ gcloud config get-value compute/zone
europe-west1-b
```

### 2. cfssl, cfssljson, and kubectl.

```bash
$ cfssl version

Version: 1.2.0
Revision: dev
Runtime: go1.6

$ kubectl version --client

Client Version: version.Info{Major:"1", Minor:"9", GitVersion:"v1.9.0", GitCommit:"925c127ec6b946659ad0fd596fa959be43f0cc05", GitTreeState:"clean", BuildDate:"2017-12-15T21:07:38Z", GoVersion:"go1.9.2", Compiler:"gc", Platform:"darwin/amd64"}
```

### 3. Сеть, Firewall
Создали сеть и фаерволлы
```bash
$ gcloud compute addresses list --filter="name=('kubernetes-the-hard-way')"

NAME                     REGION        ADDRESS        STATUS
kubernetes-the-hard-way  europe-west1  35.195.103.23  RESERVED
```

Создали контроллеры и ноды
```bash
$ gcloud compute instances list

NAME          ZONE            MACHINE_TYPE   PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP     STATUS
controller-0  europe-west1-b  n1-standard-1               10.240.0.10  35.190.220.36   RUNNING
controller-1  europe-west1-b  n1-standard-1               10.240.0.11  35.187.123.230  RUNNING
controller-2  europe-west1-b  n1-standard-1               10.240.0.12  35.187.79.173   RUNNING
worker-0      europe-west1-b  n1-standard-1               10.240.0.20  104.155.81.10   RUNNING
worker-1      europe-west1-b  n1-standard-1               10.240.0.21  146.148.5.123   RUNNING
worker-2      europe-west1-b  n1-standard-1               10.240.0.22  35.195.248.85   RUNNING
```

### 7. etcd
```bash
f3ex@controller-2:~$ ETCDCTL_API=3 etcdctl member list
3a57933972cb5131, started, controller-2, https://10.240.0.12:2380, https://10.240.0.12:2379
f98dc20bce6225a0, started, controller-0, https://10.240.0.10:2380, https://10.240.0.10:2379
ffed16798470cab5, started, controller-1, https://10.240.0.11:2380, https://10.240.0.11:2379
```

### 8. LB
```bash
$ curl --cacert ca.pem https://${KUBERNETES_PUBLIC_ADDRESS}:6443/version

{
  "major": "1",
  "minor": "9",
  "gitVersion": "v1.9.0",
  "gitCommit": "925c127ec6b946659ad0fd596fa959be43f0cc05",
  "gitTreeState": "clean",
  "buildDate": "2017-12-15T20:55:30Z",
  "goVersion": "go1.9.2",
  "compiler": "gc",
  "platform": "linux/amd64"
}
```

### 9.

```bash
f3ex@controller-0:~$ kubectl get nodes
NAME       STATUS    ROLES     AGE       VERSION
worker-0   Ready     <none>    2m        v1.9.0
worker-1   Ready     <none>    52s       v1.9.0
worker-2   Ready     <none>    7s        v1.9.0
```

### 10.

```bash
f3ex at MacBook-Pro-f3ex in ~/otus/DevOps/f4rx_microservices/kubernetes/kubernetes_the_hard_way (kubernetes-1●●)
$ kubectl get componentstatuses

NAME                 STATUS    MESSAGE              ERROR
controller-manager   Healthy   ok
scheduler            Healthy   ok
etcd-2               Healthy   {"health": "true"}
etcd-0               Healthy   {"health": "true"}
etcd-1               Healthy   {"health": "true"}

f3ex at MacBook-Pro-f3ex in ~/otus/DevOps/f4rx_microservices/kubernetes/kubernetes_the_hard_way (kubernetes-1●●)
$ kubectl get nodes

NAME       STATUS    ROLES     AGE       VERSION
worker-0   Ready     <none>    30m       v1.9.0
worker-1   Ready     <none>    28m       v1.9.0
worker-2   Ready     <none>    28m       v1.9.0
```

### 11.

```bash
$ for instance in worker-0 worker-1 worker-2; do
  gcloud compute instances describe ${instance} \
    --format 'value[separator=" "](networkInterfaces[0].networkIP,metadata.items[0].value)'
done
10.240.0.20 10.200.0.0/24
10.240.0.21 10.200.1.0/24
10.240.0.22 10.200.2.0/24
```

```bash
$ gcloud compute routes list --filter "network: kubernetes-the-hard-way"

NAME                            NETWORK                  DEST_RANGE     NEXT_HOP                  PRIORITY
default-route-18353f1dd5d990e8  kubernetes-the-hard-way  0.0.0.0/0      default-internet-gateway  1000
default-route-61f7e48458f6f541  kubernetes-the-hard-way  10.240.0.0/24                            1000
kubernetes-route-10-200-0-0-24  kubernetes-the-hard-way  10.200.0.0/24  10.240.0.20               1000
kubernetes-route-10-200-1-0-24  kubernetes-the-hard-way  10.200.1.0/24  10.240.0.21               1000
kubernetes-route-10-200-2-0-24  kubernetes-the-hard-way  10.200.2.0/24  10.240.0.22               1000
```

### 12.
```bash
$ kubectl create -f https://storage.googleapis.com/kubernetes-the-hard-way/kube-dns.yaml

service "kube-dns" created
serviceaccount "kube-dns" created
configmap "kube-dns" created
deployment "kube-dns" created
```

```bash
$ kubectl get pods -l k8s-app=kube-dns -n kube-system

NAME                        READY     STATUS    RESTARTS   AGE
kube-dns-6c857864fb-tc7g6   3/3       Running   0          28s
```

Проверка
```bash
f3ex at MacBook-Pro-f3ex in ~/otus/DevOps/f4rx_microservices/kubernetes/kubernetes_the_hard_way (kubernetes-1●●)
$ kubectl get pods -l k8s-app=kube-dns -n kube-system

NAME                        READY     STATUS    RESTARTS   AGE
kube-dns-6c857864fb-tc7g6   3/3       Running   0          28s

f3ex at MacBook-Pro-f3ex in ~/otus/DevOps/f4rx_microservices/kubernetes/kubernetes_the_hard_way (kubernetes-1●●)
$ kubectl run busybox --image=busybox --command -- sleep 3600

deployment "busybox" created

f3ex at MacBook-Pro-f3ex in ~/otus/DevOps/f4rx_microservices/kubernetes/kubernetes_the_hard_way (kubernetes-1●●)
$ kubectl get pods -l run=busybox

NAME                       READY     STATUS    RESTARTS   AGE
busybox-855686df5d-84d42   1/1       Running   0          9s

f3ex at MacBook-Pro-f3ex in ~/otus/DevOps/f4rx_microservices/kubernetes/kubernetes_the_hard_way (kubernetes-1●●)
$ POD_NAME=$(kubectl get pods -l run=busybox -o jsonpath="{.items[0].metadata.name}")


f3ex at MacBook-Pro-f3ex in ~/otus/DevOps/f4rx_microservices/kubernetes/kubernetes_the_hard_way (kubernetes-1●●)
$ kubectl exec -ti $POD_NAME -- nslookup kubernetes

Server:    10.32.0.10
Address 1: 10.32.0.10 kube-dns.kube-system.svc.cluster.local

Name:      kubernetes
Address 1: 10.32.0.1 kubernetes.default.svc.cluster.local
```

### 13. Smoke Test

Все ок, согласно гайду
```bash
$ curl -I http://${EXTERNAL_IP}:${NODE_PORT}

HTTP/1.1 200 OK
Server: nginx/1.13.9
Date: Sun, 18 Mar 2018 15:34:19 GMT
Content-Type: text/html
Content-Length: 612
Last-Modified: Tue, 20 Feb 2018 12:21:20 GMT
Connection: keep-alive
ETag: "5a8c12c0-264"
Accept-Ranges: bytes
```

## Основное задание

>Проверьте, что kubectl apply -f <filename> проходит по созданным
до этого deployment-ам (ui, post, mongo, comment) и поды
запускаются

```bash
$ kubectl get pods
NAME                                 READY     STATUS    RESTARTS   AGE
busybox-855686df5d-84d42             1/1       Running   0          9m
comment-deployment-689fb57d4-hx56w   1/1       Running   0          1m
mongo-deployment-74cccfb8-gcps5      1/1       Running   0          1m
nginx-8586cf59-swqtp                 1/1       Running   0          7m
post-deployment-6d958b5db-r58qj      1/1       Running   0          3m
ui-deployment-5c87b8c57d-crckl       1/1       Running   0          1m
```

После чего кластер разобран согласно https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/14-cleanup.md

# HW 27 Swarm-1

Создаем мастера и воркеры
```bash
for host in master-1 worker-1 worker-2; do
docker-machine create --driver google \
   --google-project docker-193517  \
   --google-zone europe-west1-b \
   --google-machine-type g1-small \
   --google-machine-image $(gcloud compute images list --filter ubuntu-1604-lts --uri) \
   ${host}
done
```


```bash
eval $(docker-machine env master-1)

$ docker swarm init
Swarm initialized: current node (yo99xlwm7cepux8ca33m14b9q) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-29iqeqgkro8b6gmdyazwgba3zaml6dkq5se7aqx6fiyw1ch2fv-7ex0f30w231dnrwf7vcorv4o0 10.132.0.2:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.


docker-machine ssh worker-1 sudo  docker swarm join --token SWMTKN-1-29iqeqgkro8b6gmdyazwgba3zaml6dkq5se7aqx6fiyw1ch2fv-7ex0f30w231dnrwf7vcorv4o0 10.132.0.2:2377

docker-machine ssh worker-2 sudo  docker swarm join --token SWMTKN-1-29iqeqgkro8b6gmdyazwgba3zaml6dkq5se7aqx6fiyw1ch2fv-7ex0f30w231dnrwf7vcorv4o0 10.132.0.2:2377

$ docker node ls
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS
yo99xlwm7cepux8ca33m14b9q *   master-1            Ready               Active              Leader
t5o5rbrmw3ygvpm16k3ovkw4s     worker-1            Ready               Active
ignpky3fcj5pxmwfs4b00t8m3     worker-2            Ready               Active

```

Управляем стеком с помощью команд:
> $ docker stack deploy/rm/services/ls STACK_NAME 

```bash
docker stack deploy --compose-file=<(docker-compose -f docker-compose.yml config 2>/dev/null) DEV

$ docker stack services DEV
ID                  NAME                MODE                REPLICAS            IMAGE                 PORTS
0orisq8ic66d        DEV_comment         replicated          0/1                 f3ex/comment:latest
eb435qnb9qq7        DEV_mongo           replicated          1/1                 mongo:3.2
qqln5hbtee97        DEV_post            replicated          0/1                 f3ex/post:latest
u4k7upntxlck        DEV_ui              replicated          0/1                 f3ex/ui:latest        *:9292->9292/tcp
```

```bash
docker node update --label-add reliability=high master-1

$  docker node ls --filter "label=reliability"
ID                  HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS


$ docker node ls -q | xargs docker node inspect  -f '{{ .ID }} [{{ .Description.Hostname }}]: {{ .Spec.Labels }}'
yo99xlwm7cepux8ca33m14b9q [master-1]: map[reliability:high]
t5o5rbrmw3ygvpm16k3ovkw4s [worker-1]: map[]
ignpky3fcj5pxmwfs4b00t8m3 [worker-2]: map[]


```

Передеплоиваем
```bash
$ docker stack deploy --compose-file=<(docker-compose -f docker-compose.yml config 2>/dev/null) DEV
Updating service DEV_ui (id: u4k7upntxlckcr4czdwoxkdqe)
Updating service DEV_comment (id: 0orisq8ic66dp5ke5hkq9b51o)
Updating service DEV_mongo (id: eb435qnb9qq714qj7w2jh9cq8)
Updating service DEV_post (id: qqln5hbtee97nh29deuq4cqgm)

$  docker stack ps DEV
ID                  NAME                IMAGE                 NODE                DESIRED STATE       CURRENT STATE             ERROR               PORTS
rw1zpeva13c0        DEV_post.1          f3ex/post:latest      worker-1            Running             Running 28 seconds ago
kp6414besejn        DEV_mongo.1         mongo:3.2             master-1            Running             Running 31 seconds ago
suwy959s8e8u        DEV_comment.1       f3ex/comment:latest   worker-1            Running             Running 31 seconds ago
q7o3qxs0fuh7        DEV_ui.1            f3ex/ui:latest        worker-2            Running             Running 35 seconds ago
u0tmwh3soje0        DEV_comment.1       f3ex/comment:latest   worker-1            Shutdown            Shutdown 33 seconds ago
xfjphj53m710        DEV_ui.1            f3ex/ui:latest        worker-2            Shutdown            Shutdown 36 seconds ago
qj3jd9odiim1        DEV_post.1          f3ex/post:latest      worker-1            Shutdown            Shutdown 29 seconds ago
mpy7203944xb        DEV_mongo.1         mongo:3.2             master-1            Shutdown            Shutdown 31 seconds ago

#Проверяем в браузере
open http://$(docker-machine ip master-1):9292

```

```bash
$ docker stack services DEV
ID                  NAME                MODE                REPLICAS            IMAGE                 PORTS
0orisq8ic66d        DEV_comment         replicated          2/2                 f3ex/comment:latest
eb435qnb9qq7        DEV_mongo           replicated          1/1                 mongo:3.2
qqln5hbtee97        DEV_post            replicated          2/2                 f3ex/post:latest
u4k7upntxlck        DEV_ui              replicated          2/2                 f3ex/ui:latest        *:9292->9292/tcp

```

> 1) Добавить в кластер еще 1 worker машину
```bash
docker-machine create --driver google \
   --google-project docker-193517  \
   --google-zone europe-west1-b \
   --google-machine-type g1-small \
   --google-machine-image $(gcloud compute images list --filter ubuntu-1604-lts --uri) \
   worker-3
   
$ docker-machine ssh worker-3 sudo  docker swarm join --token SWMTKN-1-29iqeqgkro8b6gmdyazwgba3zaml6dkq5se7aqx6fiyw1ch2fv-7ex0f30w231dnrwf7vcorv4o0 10.132.0.2:2377
This node joined a swarm as a worker.
```
2) Проследить какие контейнеры запустятся на ней
Запустился node-exporter, т.к. у него стоит глобальный деплой
```bash
$ docker stack ps DEV | grep worker-3
jl6dot12vnw5        DEV_node-exporter.mdffy8tlxxcvrj0aeynk8y7gg   prom/node-exporter:v0.15.0   worker-3            Running             Running 20 seconds ago

```
3) Увеличить число реплик микросервисов (3 - минимум)

4) Проследить какие контейнеры запустятся на новой машине.
Сравнить с пунктом 2. 
Развернулись новые контейнеры
```bash
$ docker stack ps DEV | grep worker-3
jl6dot12vnw5        DEV_node-exporter.mdffy8tlxxcvrj0aeynk8y7gg   prom/node-exporter:v0.15.0   worker-3            Running             Running about a minute ago
juxbrzam40si        DEV_ui.3                                      f3ex/ui:latest               worker-3            Running             Preparing 6 seconds ago
mbrdnmux2tly        DEV_post.3                                    f3ex/post:latest             worker-3            Running             Preparing 8 seconds ago
1zmfozs3qnm3        DEV_comment.3                                 f3ex/comment:latest          worker-3            Running             Preparing 20 seconds ago

```


```bash
$ docker inspect $(docker stack ps DEV -q --filter "Name=DEV_ui.1") --format \
"{{.Status.ContainerStatus.ContainerID}}"
2fab7fe54ceb73ad3f09499de6c23a41c5c4b632964a3d460bcd4bada3713286
e1aa48ae476817abde347f13dbcab1f5637c34f05e4bcd1b2de270035d01d1af
e6f9015bea77f61c05c074c21c150407acc951f431be121d1556599f86f7378d
```

# HW 25 Logging-1

## Основное задание

Мы поработали с логгированием на уровне докера/приложений, развернули кибану.

# HW 23 Monitoring-2

## Основное задание

Не могу выделить какие-то команды, делал просто по инструкции.

Первый дашборд:

![Grafana](images/hw23_grafana_dashboard.png?raw=true "Grafana")

Репозиторий докер хаба https://hub.docker.com/u/f3ex/


# HW 21 Monitoring-1

## Основное задание

```bash
gcloud compute firewall-rules create prometheus-default --allow tcp:9090

gcloud compute firewall-rules create puma-default --allow tcp:9292

export GOOGLE_PROJECT=docker-193517

# create docker host
docker-machine create --driver google \
    --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
    --google-machine-type n1-standard-1 \
    vm1

# configure local env
eval $(docker-machine env vm1)

docker run --rm -p 9090:9090 -d --name prometheus  prom/prometheus

$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
0dfb2d25c01b        prom/prometheus     "/bin/prometheus --c…"   24 seconds ago      Up 21 seconds       0.0.0.0:9090->9090/tcp   prometheus

$ docker-machine ip vm1
104.154.135.156

open http://$(docker-machine ip vm1):9090

docker stop prometheus
```

Навели марафет, собираем билд

```bash
export USER_NAME=f3ex

$ docker build -t $USER_NAME/prometheus monitoring/prometheus
Sending build context to Docker daemon  3.072kB
Step 1/2 : FROM prom/prometheus
 ---> c8ecf7c719c1
Step 2/2 : ADD prometheus.yml /etc/prometheus/
 ---> 734c10108fc9
Successfully built 734c10108fc9
Successfully tagged f3ex/prometheus:latest
```

```bash
for i in ui post-py comment; do cd src/$i; bash docker_build.sh; cd -; done
```

Поднимаем все
```bash
cd docker
docker-compose up -d
```

```bash
docker-compose stop post
docker-compose start post
```

Exporter
```bash
cd ../monitoring/prometheus
docker build -t $USER_NAME/prometheus .

cd ../../docker
docker-compose down
docker-compose up -d
docker-machine ssh vm1

yes > /dev/null
```

На графике смотрим node_load1

```bash
$ docker login
Login Succeeded

docker push $USER_NAME/ui
docker push $USER_NAME/comment
docker push $USER_NAME/post
docker push $USER_NAME/prometheus
# Удалите виртуалку:
docker-machine rm vm1
```

Docker hub - https://hub.docker.com/r/f3ex/

## ДЗ * (mongo exporter)
Первая в гугле ссылка меня привела на https://github.com/dcu/mongodb_exporter, проект вроде разивается, там есть Dockerfile, 
скопировал себе в hw_21 (hw_21/mongodb_exporter/), но проект у меня изначалаьно не собрался
```bash
[INFO]	Replacing existing vendor dependencies
mkdir -p release
perl -p -i -e 's/{{VERSION}}/v1.0.0/g' mongodb_exporter.go
Unescaped left brace in regex is illegal here in regex; marked by <-- HERE in m/{{ <-- HERE VERSION}}/ at -e line 1.
make: *** [Makefile:19: release] Error 255
The command '/bin/sh -c cd /go/src/github.com/dcu/mongodb_exporter && make release' returned a non-zero code: 2
```
Добавил экранирование в Makefile, собрал, загрузил образ себе https://hub.docker.com/r/f3ex/mongodb_exporter/

Для настройки нужен получить две ручки - передать адрес монги и узнать порт на котором слушает
```bash
To pass in the mongodb url securely, you can set the MONGODB_URL environment variable instead.

  -web.listen-address string
    	Address on which to expose metrics and web interface. (default ":9001")
```

docker-compose.yaml:
```yaml
  mongodb-exporter:
    container_name: mongodb-exporter
    image: f3ex/mongodb_exporter
    environment:
      - MONGODB_URL=post_db
    ports:
      - '9001:9001'
    networks:
      - reddit
```

prometheus.yaml
```yaml
  - job_name: 'mongodb'
    static_configs:
      - targets:
        - 'mongodb-exporter:9001'
```

![MongoDB exporter](images/hw21_mongodb_exporter.png?raw=true "Pipeline")

## ДЗ ** (Blackbox)
> Добавьте в Prometheus мониторинг сервисов comment, post, ui с помощью blackbox экспортера.

docker-compose.yaml
```bash
  blackbox-exporter:
    image: prom/blackbox-exporter
    ports:
      - '9115:9115'
    networks:
      - reddit
```

prometheus.yaml
```bash
  - job_name: 'blackbox'
    metrics_path: /probe
    params:
      module: [http_2xx]  # Look for a HTTP 200 response.
    static_configs:
      - targets:
        - http://c_ui:9292    # Target to probe with http.
        - http://c_comment:9292
        - http://c_post:5000
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: blackbox-exporter:9115  # The blackbox exporter's real hostname:port.
```

Но я не понял что я сделал, как сказать, что 404 с комментов и поста это ОК ? Конфиг мне кажется очень сложным и непонятным.
https://github.com/prometheus/blackbox_exporter/blob/master/CONFIGURATION.md и https://github.com/prometheus/blackbox_exporter/blob/master/example.yml

## ДЗ *** (Makefile)

Взял за основу у Nefariusmag, ценности не могу оценить, т.к. того же можно добавить через docker-compose с секциями билд и пущ.

# HW 20 Docker-7

## Основное задание

Запускаем ВМ с Gitlab и узнаем что у нас изменился адрес
```bash
gcloud compute instances start gitlab

$ terraform apply
...
gitlab_external_ip = 35.187.176.178

docker-machine rm otus-gitlab
docker-machine create --driver generic --generic-ip-address=$(terraform output gitlab_external_ip) --generic-ssh-user=subadm --generic-ssh-key ~/.ssh/appuser otus-gitlab
docker-machine env otus-gitlab
eval $(docker-machine env otus-gitlab)

# Проверяем
$ docker ps
CONTAINER ID        IMAGE                         COMMAND                  CREATED             STATUS                             PORTS                                                            NAMES
99cb6d9c4ee1        gitlab/gitlab-runner:latest   "/usr/bin/dumb-init …"   2 days ago          Up 23 seconds                                                                                       gitlab-runner-2
7a7e35a1ed25        gitlab/gitlab-runner:latest   "/usr/bin/dumb-init …"   2 days ago          Up 23 seconds                                                                                       gitlab-runner
62849345fb52        gitlab/gitlab-ce:latest       "/assets/wrapper"        3 days ago          Up 23 seconds (health: starting)   0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp, 0.0.0.0:2222->22/tcp   hw19_web_1
```

Из доки:
```bash
Add a host without a driver
You can register an already existing docker host by passing the daemon url. With that, you can have the same workflow as on a host provisioned by docker-machine.

$ docker-machine create --driver none --url=tcp://50.134.234.20:2376 custombox
$ docker-machine ls
NAME        ACTIVE   DRIVER    STATE     URL
custombox   *        none      Running   tcp://50.134.234.20:2376
```

Меняем адрес в hw_19/docker-compose.yml. Пристреливаем текушие контейнеры (со вторым ранером), и перезапускаем через композ гитлаб

Основное задание выполнено по методичке, пайплайны построены.

![Pipeline](images/hw20_pipeline.png?raw=true "Pipeline")
![Environment](images/hw20_envinment.png?raw=true "Pipeline")

## ДЗ * (Авторазварачивание environment)

>При пуше новой ветки должен создаваться сервер
для окружения с возможностью удалить его
кнопкой. 

Я пошел по пути создание ansible-плейбука hw_20/create_instance.yaml, в нем дергается модуль gce, который умеет создавать
и удалять VM (через state), так же аргументом принемает имя вети, используя ветку создает ВМ ProjectName-BranchName, в данном случае
`example2-docker-7`

Пример 
```bash
ansible-playbook hw_20/create_instance.yaml --extra-vars="instance_name=${CI_COMMIT_REF_NAME} state=active"
ansible-playbook hw_20/create_instance.yaml --extra-vars="instance_name=${CI_COMMIT_REF_NAME} state=deleted"
```

Для передачи credential файла к сервисному аккаунту использую секретные переменные в  Gitlab, перекодировав предварительно
в base64
```bash
base64 -i Docker-72e3439b3339.json
``` 

Используемая литература: 
* http://docs.ansible.com/ansible/latest/guide_gce.html
* http://docs.ansible.com/ansible/latest/gce_module.html
* https://docs.gitlab.com/ee/ci/ssh_keys/README.html - деплой приватного ssh-ключа
* https://docs.gitlab.com/ce/ci/environments.html#stopping-an-environment - остановка Окружени.

Для работы Ansible нужнен питон, определенные пакеты, так же gce-модуль требует определенных зависимостей. Я решил 
сделать отдельный Docker-контейрер (hw_20/Dockerfile) и для management операций подключать его в job'ах.  
Так же на этих job'ах исключаю before_script, мне кажется в этом пайплайне (с учетом следующего задания) он вообще лишний.
```bash
create_vm_job:
  before_script:
    - echo "skip before_script"
  image: f3ex/ansible-gcp:0.2

stop_vm_job:
  before_script:
    - echo "skip before_script"
  image: f3ex/ansible-gcp:0.2
```

Кнопка стоп сделана по мануалу из ссылки выше.
```bash
  environment:
    on_stop: stop_vm_job
```

## ДЗ ** (Деплой приложения)

Тут задача была достаточно интересной, практической, т.е. отражает то, с чем можно столкнуться в реальной работе.

Но надо отметить, что сама изначальная лаба с примером не идеальная, нет как такового диплоя, мы не используем артифакты с предыдущих шагов,
bundle install запускаем вообще на каждом шаге. Пришлось делать много костылей, и вообще прошу больше рассматривать как PoC.  
Сейчас я бы разделил само приложение и mgmt-часть по ее деплою.

Я пошел по пути на шаше build собрать докер-image из каталога reddit-microservices, поменить артифакты в gitlab regestry
и развернуть из них контейреры на этапе деплоя (deploy_except_master_branch_job).

Первое с чем я столкнулся - regestry работает только по https (https://docs.gitlab.com/ce/administration/container_registry.html)  
Можно было пойти по пути натягивания домена и сертификата с let's encrypt, но я решил пойти по пути создания несекурного
репозитория ()https://gitlab.com/gitlab-org/omnibus-gitlab/issues/1312).

Сейчас я бы пошел делать сертификат, т.к. на всех хостах с dockerd нужно добавить его разрешать и перезапускать докер.
Для меня это оказалось 3 хоста - ноутбук, сервер с gitlab и созданная машина (машины) на предыдущем шаге
```bash
root@gitlab:~# cat /etc/docker/daemon.json
{
  "insecure-registries" : ["35.187.176.178:4567"]
}

systemctl restart dockerd
```

Т.к. мы этапах билда и деплоя не знаем о доступе к ВМ, то я решил это делать через динамический инвентарь.

Проверка динамического инвентори
```bash
$ GCE_EMAIL=gitlab@docker-193517.iam.gserviceaccount.com GCE_PROJECT=docker-193517 GCE_CREDENTIALS_FILE_PATH=./Docker-72e3439b3339.json ansible -i ./hw_20/gce.py example2-test-vm -u appuser -m ping
example2-test-vm | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

Тут пришлось повозиться, очень долго не понимал как делать докер в докер, думал даже делать отдельный хост для билдов и
в качестве executor'a ставить ssh.  

Я создал отдельный раннер для билдов gitlab-runner-for-build и поменял его конфиг, чтобы "дочерний" докер-контейрер `docker`
имел доступ к докер-демону. Так же на раннер добавляется тег docker-build
```bash
cat /etc/gitlab-runner/config.toml | egrep "privileged|volumes"
    privileged = true
    volumes = ["/var/run/docker.sock:/var/run/docker.sock", "/cache"]
```
Этап сборки приложения. Навешивается тег, который связывает задачу и со специальным раннером. В этом задание собираются
три контейра и пушатся в реджестри.

```yaml
build_job:
  before_script:
    - echo "skip before_script"
  stage: build
  image: docker
  tags:
    - docker-build
  script:

    - docker login -u gitlab-ci-token -p $GITLAB_CI_TOKEN http://35.187.176.178:4567
    - docker build -t 35.187.176.178:4567/homework/example2/reddit-ui:$CI_COMMIT_REF_NAME reddit-microservices/ui/
    - docker push 35.187.176.178:4567/homework/example2/reddit-ui:$CI_COMMIT_REF_NAME
    - docker build -t 35.187.176.178:4567/homework/example2/comment:$CI_COMMIT_REF_NAME reddit-microservices/comment/
    - docker push 35.187.176.178:4567/homework/example2/comment:$CI_COMMIT_REF_NAME
    - docker build -t 35.187.176.178:4567/homework/example2/post-py:$CI_COMMIT_REF_NAME reddit-microservices/post-py/
    - docker push 35.187.176.178:4567/homework/example2/post-py:$CI_COMMIT_REF_NAME
```

Это задача для деплоя приложения. 
* Bспользуется образ с предустановленным ansible с предыдущего шага.
* Доставляется ssh-ключ и ключ сервисного аккаунта через секреты.
* Дальше запускается ansible playbook (hw_20/deploy_and_run_reddit_via_compose.yaml) для установки докера, подключению к
registry, стягиванию образов и их запуску через docker-compose (hw_20/docker-compose.yaml). Написан не оптимально, но
с учетом того, что вообще эта задача на делелю, а я у меня в распоряжение только выходные, то отправляю как есть.
```yaml
deploy_except_master_branch_job:
  before_script:
    - echo "skip before_script"
  image: f3ex/ansible-gcp:0.2
  stage: deploy_except_master_branch
  script:
    - source /env/bin/activate
    - echo "${APPUSER_SSH_KEY}" |  base64 -d > appuser_ssh_key
    - chmod 600 appuser_ssh_key
    - eval $(ssh-agent )
    - ssh-add appuser_ssh_key
    - echo "${GCP_CREDS_JSON}" | base64 -d > Docker-72e3439b3339.json
    - >
      ANSIBLE_SSH_RETRIES=5 ANSIBLE_HOST_KEY_CHECKING=False GCE_EMAIL=gitlab@docker-193517.iam.gserviceaccount.com
      GCE_PROJECT=docker-193517 GCE_CREDENTIALS_FILE_PATH=./Docker-72e3439b3339.json
      ansible-playbook -l example2-"${CI_COMMIT_REF_NAME}"
      --extra-vars="regestry_login=gitlab-ci-token regestry_password=${GITLAB_CI_TOKEN} branch=${CI_COMMIT_REF_NAME}"
      -i ./hw_20/gce.py hw_20/deploy_and_run_reddit_via_compose.yaml
  environment:
    name: manage_vm/$CI_COMMIT_REF_NAME
  only:
    - branches
  except:
    - master
```

# HW 19 Docker-6

## Основное задание

Развернуть хост

```bash
cd terraform-gitlab
terraform init
$ terraform apply
...
Outputs:

gitlab_external_ip = 35.195.159.209

$ terraform output gitlab_external_ip
35.195.159.209

# Выключить инстанс
gcloud compute instances stop gitlab

# Включить интсанс
gcloud compute instances start gitlab
```

Я мог бы сразу создать ВМ через `docker-machine create` с драйвером гугла, но решил проверить такой юзкейс, когда уже есть
просто ВМ, к примеру я купил ВДС за 3$ и решил на готовой ВДС  развернуть докер-инфраструктуру. 

sshguard блокировал мой адрес при создание docker-machine, я решил его отключить через терраформ
```hcl-terraform
  provisioner "remote-exec" {
    inline = [
      "sudo systemctl stop sshguard",
      "sudo systemctl disable sshguard",
    ]
  }
```

```bash
$ terraform output gitlab_external_ip
35.205.141.53

$ docker-machine create --driver generic --generic-ip-address=$(terraform output gitlab_external_ip) \
   --generic-ssh-user=subadm --generic-ssh-key ~/.ssh/appuser otus-gitlab
Running pre-create checks...
Creating machine...
(otus-gitlab) Importing SSH key...
Waiting for machine to be running, this may take a few minutes...
Detecting operating system of created instance...
Waiting for SSH to be available...
Detecting the provisioner...
Provisioning with ubuntu(systemd)...
Installing Docker...
Copying certs to the local machine directory...
Copying certs to the remote machine...
Setting Docker configuration on the remote daemon...
Checking connection to Docker...
Docker is up and running!
To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: docker-machine env otus-gitlab

$ docker-machine ls
NAME          ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER        ERRORS
default       -        virtualbox   Running   tcp://192.168.99.100:2376           v18.01.0-ce
otus-gitlab   -        generic      Running   tcp://35.205.71.166:2376            v18.02.0-ce

$ docker-machine status otus-gitlab
Running

$ docker-machine env otus-gitlab
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://35.205.71.166:2376"
export DOCKER_CERT_PATH="/Users/f3ex/.docker/machine/machines/otus-gitlab"
export DOCKER_MACHINE_NAME="otus-gitlab"
# Run this command to configure your shell:
# eval $(docker-machine env otus-gitlab)

$ eval $(docker-machine env otus-gitlab)

# Активируем ВМ
$ docker-machine ls
NAME          ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER        ERRORS
default       -        virtualbox   Running   tcp://192.168.99.100:2376           v18.01.0-ce
otus-gitlab   *        generic      Running   tcp://35.205.71.166:2376            v18.02.0-ce
```

```bash
docker-machine ssh otus-gitlab "sudo mkdir -p /srv/gitlab/config /srv/gitlab/data /srv/gitlab/logs"
```

Из корня репозитория выполнить:
```bash
mkdir hw_19
cd hw_19

wget https://gitlab.com/gitlab-org/omnibus-gitlab/raw/master/docker/docker-compose.yml

# Меняем IP и ssh-порт
IP=$(terraform output  -state=../terraform-gitlab/terraform.tfstate gitlab_external_ip); \
sed -i "" "s/external_url.*/external_url 'http:\/\/$IP'/g" docker-compose.yml && \
sed -i "" "s/22:22/2222:22/g" docker-compose.yml

# Запускаем
$ docker-compose up -d
Creating hw19_web_1 ... done

# Проверяем
open http://$IP/
```


```bash
$ git remote add gitlab http://$IP/homework/example.git

$ git push gitlab docker-6
Username for 'http://35.205.71.166': root
Password for 'http://root@35.205.71.166':
Counting objects: 87, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (76/76), done.
Writing objects: 100% (87/87), 28.63 KiB | 792.00 KiB/s, done.
Total 87 (delta 19), reused 0 (delta 0)
To http://35.205.71.166/homework/example.git
 * [new branch]      docker-6 -> docker-6
```

Тут добавили .gitlab-ci.yml, скопировали токен раннера из веб-интерфейса

Создаем новый раннер и регистрируем его
```bash
docker run -d --name gitlab-runner --restart always \
-v /srv/gitlab-runner/config:/etc/gitlab-runner \
-v /var/run/docker.sock:/var/run/docker.sock \
gitlab/gitlab-runner:latest

$ docker exec -it gitlab-runner gitlab-runner register
Running in system-mode.

Please enter the gitlab-ci coordinator URL (e.g. https://gitlab.com/):
http://35.205.71.166
Please enter the gitlab-ci token for this runner:
TVnFHoHzM
Please enter the gitlab-ci description for this runner:
[7a7e35a1ed25]: my-runner
Please enter the gitlab-ci tags for this runner (comma separated):
linux,xenial,ubuntu,docker
Whether to run untagged builds [true/false]:
[false]: true
Whether to lock the Runner to current project [true/false]:
[true]: false
Registering runner... succeeded                     runner=TVnFHoHz
Please enter the executor: docker, docker-ssh, parallels, virtualbox, docker+machine, shell, ssh, docker-ssh+machine, kubernetes:
docker
Please enter the default Docker image (e.g. ruby:2.1):
alpine:latest
Runner registered successfully. Feel free to start it, but if it's running already the config should be automatically reloaded!
```

```bash
git clone https://github.com/express42/reddit.git && rm -rf ./reddit/.git
git add reddit/
git commit -m "Add reddit app"
git push gitlab docker-6
```

## ДЗ * (Авто регистрация Runner)

Есть несколько вариантов зарегистрировать раннер. Я сначал нашел ссылку https://gitlab.com/gitlab-org/gitlab-runner/issues/1802,
ее и использую в примере. Можно еще через ENV задать https://gitlab.com/gitlab-org/gitlab-runner/blob/master/docs/commands/README.md
т.е. как-то так. Вариант хорош для композа
```bash
export CI_SERVER_URL=http://gitlab.example.com
export RUNNER_NAME=my-runner
export REGISTRATION_TOKEN=my-registration-token
export REGISTER_NON_INTERACTIVE=true
gitlab-runner register
```

```bash
docker run -d --name gitlab-runner-2 --restart always \
-v /srv/gitlab-runner/config:/etc/gitlab-runner \
-v /var/run/docker.sock:/var/run/docker.sock \
gitlab/gitlab-runner:latest

docker exec -it gitlab-runner-2 gitlab-runner register --non-interactive \
 --description my-runner-2 \
 --url http://${IP} \
 --registration-token afCUy7ynZ8FooZmCpQq4 \
 --executor docker \
 --docker-image alpine:latest \
 --run-untagged --locked=false
```

Пример
```bash
$ docker exec -it gitlab-runner-2 gitlab-runner register --non-interactive \
 --description my-runner-2 \
 --url http://35.205.71.166 \
 --registration-token TVnFHoHz \
 --executor docker \
 --docker-image alpine:latest \
 --run-untagged \
 --locked=false
Running in system-mode.

Registering runner... succeeded                     runner=TVnFHoHz
Runner registered successfully. Feel free to start it, but if it's running already the config should be automatically reloaded!
```

Теперь два теста работают параллельно, только судя по всему это не будет работать, т.к. образ докер с шага build есть только
на одном раннере. Надо делать как-то через артифакты... В общем непонятно пока, т.к. переодически получал ошибку, а иногда билд собирался..:
```bash
ERROR: Job failed (system failure): Error: No such container: dccd19b9b378b751df9c5e79383a2566a16aa044ce5ee4ae15893d9bd112bfb3
```

Теперь можно создать хоть 100, хоть 1000 ранеров:
```bash
for i in `seq 1 100`
do
  docker run -d --name gitlab-runner-${i} ...
  docker exec -it gitlab-runner-${i} --description my-runner-${i} ...
done

```

## ДЗ ** (Нотификация в слак)
Нотификации идут в канал https://devops-team-otus.slack.com/messages/C8C9R4J1J/details/?

# HW 17 Docker-4

## Основное задание

```bash
#None network driver
docker run --network none --rm -d --name net_test joffotron/docker-net-tools -c "sleep 100"
docker exec -ti net_test ifconfig
# Тут виден только loopback интерфейс


# Host network driver
docker run --network host --rm -d --name net_test joffotron/docker-net-tools -c "sleep 100"
# Сравните выводы команд:
docker exec -ti net_test ifconfig
docker-machine ssh docker-host ifconfig
# Вывод совпадает, в контейнер прокинуты все хостовые сети

docker run --network host -d nginx
# Запустите несколько раз (2-4)
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
54f131b625aa        nginx               "nginx -g 'daemon of…"   2 seconds ago       Up 2 seconds                                 pensive_bell
1fb4b7667f47        nginx               "nginx -g 'daemon of…"   29 seconds ago      Up 28 seconds                                trusting_wing
..

$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
1fb4b7667f47        nginx               "nginx -g 'daemon of…"   31 seconds ago      Up 31 seconds                                trusting_wing

# nginx-контейнеры завершаются, т.к. не могут подключиться к 80-му порту (он занят первым контейнером). 
$ docker run --network host -t nginx
2018/02/06 06:42:44 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address already in use)
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
2018/02/06 06:42:44 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address already in use)
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
2018/02/06 06:42:44 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address already in use)
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
2018/02/06 06:42:44 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address already in use)
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
2018/02/06 06:42:44 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address already in use)
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
2018/02/06 06:42:44 [emerg] 1#1: still could not bind()
nginx: [emerg] still could not bind()

# Как посмотреть логи уже выключенного контейнера ?
$ docker ps -a
CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS                      PORTS                    NAMES
8059bf765b04        nginx               "nginx -g 'daemon of…"   32 seconds ago       Exited (1) 30 seconds ago                            pensive_spence
ec69bfc97771        nginx               "nginx -g 'daemon of…"   About a minute ago   Exited (0) 41 seconds ago                            sad_poitras
54f131b625aa        nginx               "nginx -g 'daemon of…"   3 minutes ago        Exited (1) 3 minutes ago                             pensive_bell
65a783b4ed1d        nginx               "nginx -g 'daemon of…"   3 minutes ago        Exited (1) 3 minutes ago                             agitated_bose
fc630cd31fe4        nginx               "nginx -g 'daemon of…"   3 minutes ago        Exited (1) 3 minutes ago                             tender_noether
8fdff56a3bcd        nginx               "nginx -g 'daemon of…"   3 minutes ago        Exited (1) 3 minutes ago                             eager_feynman
8b8c7c328a46        nginx               "nginx -g 'daemon of…"   3 minutes ago        Exited (1) 3 minutes ago                             goofy_hugle
1fb4b7667f47        nginx               "nginx -g 'daemon of…"   4 minutes ago        Up 4 minutes                                         trusting_wing
...

# Ответ
$ docker logs 8b8c7c328a46
2018/02/06 06:39:17 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address already in use)
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
2018/02/06 06:39:17 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address already in use)
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
2018/02/06 06:39:17 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address already in use)
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
2018/02/06 06:39:17 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address already in use)
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
2018/02/06 06:39:17 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address already in use)
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
2018/02/06 06:39:17 [emerg] 1#1: still could not bind()
nginx: [emerg] still could not bind()

# Остановить все контейнеры
docker kill $(docker ps -q)
```

**ДЗ \***

```bash
# Заходим на докер-хост
docker-machine ssh docker-host
sudo ln -s /var/run/docker/netns /var/run/netns

$ sudo ip netns
default

#None network driver
docker run --network none --rm -d --name net_test joffotron/docker-net-tools -c "sleep 100"
$ docker-machine ssh docker-host sudo ip netns
791b14dfa49b
default

docker run --network host --rm -d --name net_test joffotron/docker-net-tools -c "sleep 100"
$ docker-machine ssh docker-host sudo ip netns
RTNETLINK answers: Invalid argument
RTNETLINK answers: Invalid argument
791b14dfa49b
default
```




```bash
# Создадим bridge-сеть в docker (флаг --driver указывать необязательно, т.к. по-умолчанию используется bridge
$ docker network create reddit --driver bridge
Error response from daemon: network with name reddit already exists
# Она создана на предыдущем занятие. Запишу как смотреть сети и пересоздавать ее
$ docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
2b5b87b34cdf        bridge              bridge              local
327914d53ab0        host                host                local
f15cf539fa3e        none                null                local
8be2c5d0abe1        reddit              bridge              local
$ docker network rm 8be2c5d0abe1
8be2c5d0abe1
$ docker network create reddit --driver bridge
851cc9e34a68cbf501a546612b9fc269ed2c687cfc45cb49f65ae00b1ae7962e

# Запустим наш проект reddit с использованием bridge-сети
docker run -d --network=reddit mongo:latest &&\
docker run -d --network=reddit f3ex/post:1.0 &&\
docker run -d --network=reddit f3ex/comment:1.0 &&\
docker run -d --network=reddit -p 9292:9292 f3ex/ui:1.0

# Проверяем, не работает. Нет подключения к БД.

# Решением проблемы будет присвоение контейнерам имен или сетевых алиасов при старте:
# --name <name> (можно задать только 1 имя)
# --network-alias <alias-name> (можно задать множество алиасов)

docker kill $(docker ps -q) ;\
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest &&\
docker run -d --network=reddit --network-alias=post f3ex/post:1.0 &&\
docker run -d --network=reddit --network-alias=comment f3ex/comment:1.0 &&\
docker run -d --network=reddit -p 9292:9292 f3ex/ui:1.0
```

```bash
# Создадим docker-сети
docker network create back_net --subnet=10.0.2.0/24
docker network create front_net --subnet=10.0.1.0/24

docker run -d --network=front_net -p 9292:9292 --name ui f3ex/ui:1.0 &&\
docker run -d --network=back_net --name comment f3ex/comment:1.0 &&\
docker run -d --network=back_net --name post f3ex/post:1.0 &&\
docker run -d --network=back_net --name mongo_db --network-alias=post_db --network-alias=comment_db mongo:latest

# Из-за того, что мы используем name и после остановки через kill - мы не можем запустить новый котнейнер.
# В моем случае пропал "-" при копирование из слайда и я решил "килльнуть" все вм и пересоздать, и получил ошибку:
docker: Error response from daemon: Conflict. The container name "/ui" is already in use by container "19c9e88a4f5f3d8b4003111c0df9ae3f05dc92539737802c28e6c9634b5c6f48". You have to remove (or rename) that container to be able to reuse that name.
See 'docker run --help'
# Решил удалить все выключенные контейнеры
$ docker container prune
WARNING! This will remove all stopped containers.
Are you sure you want to continue? [y/N] y
Deleted Containers:
28fe3e5183ca7192514d0b877a80b79d476c43595de305a93c8b6727bc339031
...
Total reclaimed space: 41.42MB

$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES


# Docker при инициализации контейнера может подключить к нему только 1 сеть.
# Дополнительные сети подключаются командой:
> docker network connect <network> <container>

docker network connect front_net post
docker network connect front_net comment
```

Docker compose
```bash
export USERNAME=f3ex
# т.к. конейнеры уже есть, получаем ошибку
$ docker-compose up -d
...
Creating redditmicroservices_ui_1      ... error
...

ERROR: for ui  Cannot start service ui: driver failed programming external connectivity on endpoint redditmicroservices_ui_1 (97234a35ae7296d6d7d1f15562fe9361f63d1a69730a73abf0cb16858a306fcd): Bind for 0.0.0.0:9292 failed: port is already allocated
ERROR: Encountered errors while bringing up the project.

$ docker-compose ps
            Name                          Command              State       Ports
----------------------------------------------------------------------------------
redditmicroservices_comment_1   puma                          Up
redditmicroservices_post_1      python3 post_app.py           Up
redditmicroservices_post_db_1   docker-entrypoint.sh mongod   Up         27017/tcp
redditmicroservices_ui_1        puma                          Exit 128

# Останавливаем контейнеры в композе
$ docker-compose stop
Stopping redditmicroservices_post_db_1 ... done
Stopping redditmicroservices_post_1    ... done
Stopping redditmicroservices_comment_1 ... done

# Убиваем запущенные ранее
$ docker kill $(docker ps -q)
55cb13d016a1
9e7a0841088c
f767a53e8fb6
cb0c9532cbf3

# Перезапускаем
$ docker-compose up -d
Starting redditmicroservices_comment_1 ...
Starting redditmicroservices_ui_1 ...
Starting redditmicroservices_post_1 ...
Starting redditmicroservices_post_1 ... done

# Проверяем
$ docker-compose ps
            Name                          Command             State           Ports
--------------------------------------------------------------------------------------------
redditmicroservices_comment_1   puma                          Up
redditmicroservices_post_1      python3 post_app.py           Up
redditmicroservices_post_db_1   docker-entrypoint.sh mongod   Up      27017/tcp
redditmicroservices_ui_1        puma                          Up      0.0.0.0:9292->9292/tcp


```

## ДЗ ** (Bridge network driver)
```bash
docker-machine ssh docker-host
sudo apt update && sudo apt install bridge-utils
$ sudo docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
44fcc5ac9278        back_net            bridge              local
2b5b87b34cdf        bridge              bridge              local
f8b1242c0e61        front_net           bridge              local
327914d53ab0        host                host                local
f15cf539fa3e        none                null                local
851cc9e34a68        reddit              bridge              local

$ ifconfig | grep br
br-44fcc5ac9278 Link encap:Ethernet  HWaddr 02:42:0a:f9:3c:64
br-851cc9e34a68 Link encap:Ethernet  HWaddr 02:42:ad:d2:2c:f7
br-f8b1242c0e61 Link encap:Ethernet  HWaddr 02:42:23:05:65:e1

$ brctl show br-f8b1242c0e61
bridge name	bridge id		STP enabled	interfaces
br-f8b1242c0e61		8000.0242230565e1	no		veth017ae9b
							veth956cd50
							vetha32dc0e

$ brctl show br-44fcc5ac9278
bridge name	bridge id		STP enabled	interfaces
br-44fcc5ac9278		8000.02420af93c64	no		veth84c2e64
							vethbc5b7e3
							vethc783527

$ brctl show br-851cc9e34a68
bridge name	bridge id		STP enabled	interfaces
br-851cc9e34a68		8000.0242add22cf7	no

$  sudo iptables -nL -t nat
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination
DOCKER     all  --  0.0.0.0/0            0.0.0.0/0            ADDRTYPE match dst-type LOCAL

Chain INPUT (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
DOCKER     all  --  0.0.0.0/0           !127.0.0.0/8          ADDRTYPE match dst-type LOCAL

Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination
MASQUERADE  all  --  10.0.1.0/24          0.0.0.0/0
MASQUERADE  all  --  10.0.2.0/24          0.0.0.0/0
MASQUERADE  all  --  172.18.0.0/16        0.0.0.0/0
MASQUERADE  all  --  172.17.0.0/16        0.0.0.0/0
MASQUERADE  tcp  --  10.0.1.2             10.0.1.2             tcp dpt:9292

Chain DOCKER (2 references)
target     prot opt source               destination
RETURN     all  --  0.0.0.0/0            0.0.0.0/0
RETURN     all  --  0.0.0.0/0            0.0.0.0/0
RETURN     all  --  0.0.0.0/0            0.0.0.0/0
RETURN     all  --  0.0.0.0/0            0.0.0.0/0
DNAT       tcp  --  0.0.0.0/0            0.0.0.0/0            tcp dpt:9292 to:10.0.1.2:9292

$ ps ax | grep [d]ocker-proxy
 6138 ?        Sl     0:00 /usr/bin/docker-proxy -proto tcp -host-ip 0.0.0.0 -host-port 9292 -container-ip 10.0.1.2 -container-port 9292
```

## HW 17 ДЗ***
redditmicroservices_comment_1  
COMPOSE_PROJECT_NAME  
Sets the project name. This value is prepended along with the service name to the container on start up. For example, if your project name is myapp and it includes two services db and web, then Compose starts containers named myapp_db_1 and myapp_web_1 respectively.

```bash
container_name
Specify a custom container name, rather than a generated default name.

container_name: my-web-container
Because Docker container names must be unique, you cannot scale a service beyond 1 container if you have specified a custom name. Attempting to do so results in an error.

Note: This option is ignored when deploying a stack in swarm mode with a (version 3) Compose file.
```
```bash
$ docker-compose ps
  Name                Command             State           Ports
------------------------------------------------------------------------
c_comment   puma                          Up
c_post      python3 post_app.py           Up
c_post_db   docker-entrypoint.sh mongod   Up      27017/tcp
c_ui        puma                          Up      0.0.0.0:9292->9292/tcp
```

## 17 ДЗ**** (Override)
Тома будут пробрасываться с хостовой машины (docker-host), а не с ноутбука
```yaml
version: '3.3'
services:

  ui:
    command: ["puma", "--debug", "-w", "2"]
#    volumes:
#      - /apps/ui:/app

#  post:
#    volumes:
#      - /apps/post-py:/app

  comment:
    command: ["puma", "--debug", "-w", "2"]
#    volumes:
#      - /apps/comment:/app

```

# HW 16 Dockder-3

## Основное задание

Проверяем и подключаемся к докер машине
```bash
f3ex at MacBook-Pro-f3ex in ~/otus/DevOps/f4rx_microservices (docker-3●●)
$ docker-machine ls
NAME          ACTIVE   DRIVER   STATE     URL                        SWARM   DOCKER        ERRORS
docker-host   -        google   Running   tcp://35.195.14.171:2376           v18.01.0-ce

f3ex at MacBook-Pro-f3ex in ~/otus/DevOps/f4rx_microservices (docker-3●●)
$ docker-machine env docker-host
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://35.195.14.171:2376"
export DOCKER_CERT_PATH="/Users/f3ex/.docker/machine/machines/docker-host"
export DOCKER_MACHINE_NAME="docker-host"
# Run this command to configure your shell:
# eval $(docker-machine env docker-host)

f3ex at MacBook-Pro-f3ex in ~/otus/DevOps/f4rx_microservices (docker-3●●)
$ eval $(docker-machine env docker-host)
```

Проблема со сборкой
```bash
$ docker build -t f3ex/comment:1.0 ./comment
Sending build context to Docker daemon  12.29kB
Step 1/11 : FROM ruby:2.2
2.2: Pulling from library/ruby
...
Step 6/11 : ADD Gemfile* $APP_HOME/
 ---> 1eca1ea1d8af
Step 7/11 : RUN bundle install
 ---> Running in 4716656b3652
Fetching gem metadata from https://rubygems.org/.........
Fetching bson 4.2.2
Installing bson 4.2.2 with native extensions
Fetching bson_ext 1.5.1
Installing bson_ext 1.5.1 with native extensions
Gem::Ext::BuildError: ERROR: Failed to build gem native extension.

    current directory: /usr/local/bundle/gems/bson_ext-1.5.1/ext/cbson
/usr/local/bin/ruby -r ./siteconf20180203-5-1o09kmw.rb extconf.rb
Cannot allocate memory - /usr/local/bin/ruby -r ./siteconf20180203-5-1o09kmw.rb
extconf.rb 2>&1

Gem files will remain installed in /usr/local/bundle/gems/bson_ext-1.5.1 for
inspection.
Results logged to
/usr/local/bundle/extensions/x86_64-linux/2.2.0/bson_ext-1.5.1/gem_make.out

An error occurred while installing bson_ext (1.5.1), and Bundler cannot
continue.
Make sure that `gem install bson_ext -v '1.5.1'` succeeds before bundling.

In Gemfile:
  bson_ext
The command '/bin/sh -c bundle install' returned a non-zero code: 5
```

Для диагностики нужно зайти в контейнер, который создан на предыдущем шаге
```bash
Step 6/11 : ADD Gemfile* $APP_HOME/
 ---> 1eca1ea1d8af
Step 7/11 : RUN bundle install

docker run --rm -it 1eca1ea1d8af sh

$ bundle install

Gem::Ext::BuildError: ERROR: Failed to build gem native extension.

    current directory: /usr/local/bundle/gems/puma-3.10.0/ext/puma_http11
/usr/local/bin/ruby -r ./siteconf20180204-6-1fyep6x.rb extconf.rb
Cannot allocate memory - /usr/local/bin/ruby -r ./siteconf20180204-6-1fyep6x.rb
extconf.rb 2>&1

Gem files will remain installed in /usr/local/bundle/gems/puma-3.10.0 for
inspection.
```
Пересоздаем докер хост
```bash
f3ex at MacBook-Pro-f3ex in ~/otus/DevOps/f4rx_microservices/reddit-microservices (docker-3●●)
$ docker-machine rm docker-host
About to remove docker-host
WARNING: This action will delete both local reference and remote instance.
Are you sure? (y/n): y
(docker-host) Deleting instance.
(docker-host) Waiting for instance to delete.
(docker-host) Deleting disk.
(docker-host) Waiting for disk to delete.
Successfully removed docker-host

f3ex at MacBook-Pro-f3ex in ~/otus/DevOps/f4rx_microservices/reddit-microservices (docker-3●●)
$ docker-machine ls
NAME   ACTIVE   DRIVER   STATE   URL   SWARM   DOCKER   ERRORS

f3ex at MacBook-Pro-f3ex in ~/otus/DevOps/f4rx_microservices/reddit-microservices (docker-3●●)
$ docker-machine create --driver google \
--google-project docker-193517 \
--google-zone europe-west1-b \
--google-machine-type g1-small \
--google-machine-image $(gcloud compute images list --filter ubuntu-1604-lts --uri) \
docker-host
Running pre-create checks...
(docker-host) Check that the project exists
(docker-host) Check if the instance already exists
Creating machine...
(docker-host) Generating SSH Key
(docker-host) Creating host...
(docker-host) Opening firewall ports
(docker-host) Creating instance
(docker-host) Waiting for Instance
...

f3ex at MacBook-Pro-f3ex in ~/otus/DevOps/f4rx_microservices/reddit-microservices (docker-3●●)
$ eval $(docker-machine env docker-host)

f3ex at MacBook-Pro-f3ex in ~/otus/DevOps/f4rx_microservices/reddit-microservices (docker-3●●)
$ docker-machine ls
NAME          ACTIVE   DRIVER   STATE     URL                        SWARM   DOCKER        ERRORS
docker-host   *        google   Running   tcp://35.205.71.166:2376           v18.01.0-ce

f3ex at MacBook-Pro-f3ex in ~/otus/DevOps/f4rx_microservices/reddit-microservices (docker-3●●)
$ docker system df
TYPE                TOTAL               ACTIVE              SIZE                RECLAIMABLE
Images              0                   0                   0B                  0B
Containers          0                   0                   0B                  0B
Local Volumes       0                   0                   0B                  0B
Build Cache                                                 0B                  0B
```

Теперь собираем:
```bash
docker pull mongo:latest

docker build -t f3ex/post:1.0 ./post-py

docker build -t f3ex/comment:1.0 ./comment

docker build -t f3ex/ui:1.0 ./ui
```

**Вопрос.** Обратите внимание! Cборка ui началась не спервого шага. Подумайте - почему?  
**Ответ.** Использовался кеш от сборки контейнера с комментариями
```bash
Step 5/13 : WORKDIR $APP_HOME
 ---> Using cache
 ---> 2264799437df
```

```bash
$ docker network create reddit
8be2c5d0abe17b0c129acadd7155ea84bd273e76e2fe1ca8728670b3d2ca4690

$ docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
2b5b87b34cdf        bridge              bridge              local
327914d53ab0        host                host                local
f15cf539fa3e        none                null                local
8be2c5d0abe1        reddit              bridge              local

$ docker network inspect 8be2c5d0abe1
[
    {
        "Name": "reddit",
        "Id": "8be2c5d0abe17b0c129acadd7155ea84bd273e76e2fe1ca8728670b3d2ca4690",
        "Created": "2018-02-04T09:02:33.423445913Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "172.18.0.0/16",
                    "Gateway": "172.18.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {},
        "Options": {},
        "Labels": {}
    }
]

docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest

docker run -d --network=reddit --network-alias=post f3ex/post:1.0

docker run -d --network=reddit --network-alias=comment f3ex/comment:1.0

docker run -d --network=reddit -p 9292:9292 f3ex/ui:1.0


$ docker ps -a
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
8ab63e4da0f3        f3ex/ui:1.0         "puma"                   2 minutes ago       Up 2 minutes        0.0.0.0:9292->9292/tcp   serene_almeida
dc6c1dff7c5a        f3ex/comment:1.0    "puma"                   4 minutes ago       Up 4 minutes                                 angry_hypatia
839e41699bf0        f3ex/post:1.0       "python3 post_app.py"    4 minutes ago       Up 4 minutes                                 awesome_hoover
4f74113defa5        mongo:latest        "docker-entrypoint.s…"   5 minutes ago       Up 5 minutes        27017/tcp                competent_curran
```

```bash
docker build -t <your-login>/ui:2.0 ./ui
```

**Вопрос.** с какого шага началась сборка?  
**Ответ.** С первого, т.к. мы поменяли базовый образ и наши кеши стали не актуальные (они для другого базового образа).

В ДЗ ** у меня собран образ на базе alpine и ужат в рамках ДЗ ***, поэтому версия 3.1
```bash
docker kill $(docker ps -q) ;\
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest &&\
docker run -d --network=reddit --network-alias=post f3ex/post:1.0 &&\
docker run -d --network=reddit --network-alias=comment f3ex/comment:1.0 &&\
docker run -d --network=reddit -p 9292:9292 f3ex/ui:3.1
```

```bash
docker volume create reddit_db

docker kill $(docker ps -q) ;\
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db -v reddit_db:/data/db mongo:latest &&\
docker run -d --network=reddit --network-alias=post f3ex/post:1.0 &&\
docker run -d --network=reddit --network-alias=comment f3ex/comment:1.0 &&\
docker run -d --network=reddit -p 9292:9292 f3ex/ui:3.1
```

Теперь пост остается при перезапуске контейнеров.

## ДЗ * (Сетевые алиасы)

```bash
# Убиваем контейнеры
$ docker kill $(docker ps -q)
8ab63e4da0f3
dc6c1dff7c5a
839e41699bf0
4f74113defa5

$ grep ENV ./*/Dockerfile | grep HOST
./comment/Dockerfile:ENV COMMENT_DATABASE_HOST comment_db
./post-py/Dockerfile:ENV POST_DATABASE_HOST post_db
./ui/Dockerfile:ENV POST_SERVICE_HOST post
./ui/Dockerfile:ENV COMMENT_SERVICE_HOST comment

docker run -d --network=reddit --network-alias=new_post_db --network-alias=new_comment_db mongo:latest &&\
docker run --env POST_DATABASE_HOST=new_post_db -d --network=reddit --network-alias=new_post f3ex/post:1.0 &&\
docker run --env COMMENT_DATABASE_HOST=NEW_comment_db -d --network=reddit --network-alias=new_comment f3ex/comment:1.0 &&\
docker run --env POST_SERVICE_HOST=new_post --env COMMENT_SERVICE_HOST=new_comment -d --network=reddit -p 9292:9292 f3ex/ui:1.0
```

## ДЗ ** (Сборка с alpine)
Образ занимает 205MB Мб, и то часть можно почистить. В ДЗ *** получилось уменьшить образ до 37.5 Мб 
Dockerfile:
```bash
FROM alpine

# Почему нет ruby-json в зависимостях в Gemfile ????
RUN apk add --no-cache build-base ruby ruby-bundler ruby-dev ruby-json
RUN gem install bundler --no-ri --no-rdoc
```
```bash
$ docker images f3ex/ui
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
f3ex/ui             3.0                 48d230a3d45c        2 minutes ago       205MB
f3ex/ui             2.0                 7816083278f9        9 hours ago         453MB
f3ex/ui             1.0                 5b97ad913b7a        11 hours ago        775MB
```

## ДЗ *** (Ужать образ)
Итоговый докер файл у меня получился следующий:
```Dockerfile
FROM alpine

ENV APP_HOME=/app
ENV POST_SERVICE_HOST=post
ENV POST_SERVICE_PORT=5000
ENV COMMENT_SERVICE_HOST=comment
ENV COMMENT_SERVICE_PORT=9292

WORKDIR $APP_HOME

ADD . $APP_HOME

# Почему нет ruby-json в зависимостях в Gemfile ????
RUN apk add --no-cache build-base ruby ruby-bundler ruby-dev ruby-json && \
    gem install bundler --no-ri --no-rdoc && cd $APP_HOME && bundle install && apk del build-base

CMD ["puma"]

```

Можно сжать ENV'ы, но выигрыша по песту нет.

```Dockerfile
ENV APP_HOME=/app POST_SERVICE_HOST=post \
    POST_SERVICE_PORT=5000 \
    COMMENT_SERVICE_HOST=comment \
    COMMENT_SERVICE_PORT=9292
```

Основное действие, которое оказывается на размер, что мы удаляем build-base из образа. Если это сделать в два RUN'а,
то удаленные файлы все равно останутся в слоях image. 

Образ весит 60 Мб
```bash
$ docker image ls f3ex/ui
REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE
f3ex/ui             3.1                 5e995e812064        About a minute ago   60.2MB
f3ex/ui             3.0                 f653c0094d88        43 minutes ago       205MB
f3ex/ui             2.0                 7816083278f9        10 hours ago         453MB
f3ex/ui             1.0                 5b97ad913b7a        12 hours ago         775MB
```

Если дропнуть кеши и ненужные либы, получилось ужать до 37.5 Мб
```Dockerfile
RUN apk add --no-cache build-base ruby ruby-bundler ruby-dev ruby-json && \
    gem install bundler --no-ri --no-rdoc && bundle install && apk del build-base ruby-dev && \
    rm -rf /usr/share/terminfo/ && rm -rf /root/.bundle/cache/
```

```bash
$ docker image ls f3ex/ui
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
f3ex/ui             3.1                 5d61a248f112        3 seconds ago       37.5MB
f3ex/ui             3.0                 f653c0094d88        About an hour ago   205MB
f3ex/ui             2.0                 7816083278f9        11 hours ago        453MB
f3ex/ui             1.0                 5b97ad913b7a        12 hours ago        775MB
```

# HW 15 Docker-2

Развернили в GCP виртуальные машину в качетстве docker-хоста, создали свой докерфайл, собрали имадж(?), и запустили докер-контейнер.
Так же загрузили образ в докер-хаб - https://hub.docker.com/r/f3ex/otus-reddit/

## Основное задание

Команды для себя
```bash
docker-machine -v

$ gcloud compute images list --filter ubuntu-1604-lts --uri
https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-1604-xenial-v20180126

docker-machine create --driver google \
--google-project docker-193517 \
--google-zone europe-west1-b \
--google-machine-type f1-micro \
--google-machine-image $(gcloud compute images list --filter ubuntu-1604-lts --uri) \
docker-host

$ docker-machine ls
$ docker-machine ls
NAME          ACTIVE   DRIVER   STATE     URL                        SWARM   DOCKER        ERRORS
docker-host   -        google   Running   tcp://35.195.14.171:2376           v18.01.0-ce

$ docker-machine env docker-host
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://35.195.14.171:2376"
export DOCKER_CERT_PATH="/Users/f3ex/.docker/machine/machines/docker-host"
export DOCKER_MACHINE_NAME="docker-host"
# Run this command to configure your shell:
# eval $(docker-machine env docker-host)


# Сборка из Dockerfile
docker build -t reddit:latest .
...
Successfully built b975f22b9884
Successfully tagged reddit:latest

docker images -a

docker run --name reddit -d --network=host reddit:latest

docker-machine ls


 gcloud compute firewall-rules create reddit-app \
 --allow tcp:9292 --priority=65534 \
 --target-tags=docker-machine \
 --description="Allow TCP connections" \
 --direction=INGRESS
 
docker login

docker tag reddit:latest f3ex/otus-reddit:1.0

docker push f3ex/otus-reddit:1.0

# Удалить хост
docker-machine rm docker-host
```

Наблюдение, у меня команда _docker build -t reddit:latest ._ два раза вывалилась с ошибкой установки зависимостей руби

## ДЗ *

Namespaces  
Сравните вывод:  
* docker run --rm -ti tehbilly/htop  
* docker run --rm --pid host -ti tehbilly/htop  

Первая команда показывает только один процесс с pid 1 (htop), вторая команда показывает процессы хостовой системы  _--pid string PID namespace to use_.
PID htop в этом случае 6431 (номер не важен, смысл, что это не pid 1), т.е. докер процесс "цепляется" к хостовым процессам.  
Но хотя htop запущен из под root'a, мне не удалось "убить" пользовательский процесс на хосте
```bash
kill: can't kill pid 6549: Permission denied
``` 

# HW 14 Docker-1

## Основное задание

Команды для себя

```bash
docker version
docker info

docker run hello-world 

docker ps
docker ps -a

docker images

docker run -it ubuntu:16.04 /bin/bash

docker start <u_container_id>
docker attach <u_container_id>

Ctrl + p, Ctrl + q

docker exec -it <u_container_id> bash 

docker commit f9c1217b84d6 yourname/ubuntu-tmp-file

docker images

docker ps -q

docker system df

docker rm $(docker ps -a -q)

docker rmi $(docker images -q) 
```

Заметки.
Если не указывать флаг --rm при запуске docker run, то после остановки контейнер вместе с содержимым остается на диске

• docker run = docker create + docker start + docker attach*
• docker create используется, когда не нужно стартовать контейнер сразу
• в большинстве случаев используется docker run
* при наличии опции -i

• -i – запускает контейнер в foreground режиме (docker attach)
• -d – запускает контейнер в background режиме
• -t создает TTY
• docker run -it ubuntu:16.04 bash
• docker run -dt nginx:latest

```bash
f3ex at MacBook-Pro-f3ex in ~/otus/DevOps/f4rx_microservices (docker-1)
$ docker version
Client:
 Version:	17.12.0-ce
 API version:	1.35
 Go version:	go1.9.2
 Git commit:	c97c6d6
 Built:	Wed Dec 27 20:03:51 2017
 OS/Arch:	darwin/amd64

Server:
 Engine:
  Version:	17.12.0-ce
  API version:	1.35 (minimum version 1.12)
  Go version:	go1.9.2
  Git commit:	c97c6d6
  Built:	Wed Dec 27 20:12:29 2017
  OS/Arch:	linux/amd64
  Experimental:	true

f3ex at MacBook-Pro-f3ex in ~/otus/DevOps/f4rx_microservices (docker-1)
$ docker info
Containers: 0
 Running: 0
 Paused: 0
 Stopped: 0
Images: 0
Server Version: 17.12.0-ce
Storage Driver: overlay2
 Backing Filesystem: extfs
 Supports d_type: true
 Native Overlay Diff: true
Logging Driver: json-file
Cgroup Driver: cgroupfs
...
```
## ДЗ *

Image - просто ораз диска (hdd), контейрен это диск + запущенный процесс с выделенными ресурсами. Так у контейнера присутстует:
* State (статус, PID, дата запуска и т.д.)
* HostConfig (DNS, CGROUPS, память, CPU и другие настройки/лимиты)
* Маунты (ну это логично, нет смысла маунтить с хоста в hdd)
* NetworkSettings - сетевые настройки, тоже только у запущенного процесса
* Config - есть и там и там
* У Image есть мета-информация, предназначенная для запуска контейнера - ОС, архитектура и т.д.
