# Aleksey Stepanenko

Table of Contents
=================

   * [Aleksey Stepanenko](#aleksey-stepanenko)
   * [Table of Contents](#table-of-contents)
   * [HW 15 Docker-2](#hw-15-docker-2)
      * [Основное задание](#Основное-задание)
      * [ДЗ *](#ДЗ-)
   * [HW 14 Docker-1](#hw-14-docker-1)
      * [Основное задание](#Основное-задание-1)
      * [ДЗ *](#ДЗ--1)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)

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
