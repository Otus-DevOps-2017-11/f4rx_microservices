# Aleksey Stepanenko

Table of Contents
=================

   * [Aleksey Stepanenko](#aleksey-stepanenko)
      * [HW 14 Docker-1](#hw-14-docker-1)
         * [Основное задание](#Основное-задание)
         * [ДЗ *](#ДЗ-)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)

## HW 14 Docker-1

### Основное задание

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
### ДЗ *

Image - просто ораз диска (hdd), контейрен это диск + запущенный процесс с выделенными ресурсами. Так у контейнера присутстует:
* State (статус, PID, дата запуска и т.д.)
* HostConfig (DNS, CGROUPS, память, CPU и другие настройки/лимиты)
* Маунты (ну это логично, нет смысла маунтить с хоста в hdd)
* NetworkSettings - сетевые настройки, тоже только у запущенного процесса
* Config - есть и там и там
* У Image есть мета-информация, предназначенная для запуска контейнера - ОС, архитектура и т.д.
