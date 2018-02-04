# Aleksey Stepanenko

Table of Contents
=================

   * [Aleksey Stepanenko](#aleksey-stepanenko)
   * [Table of Contents](#table-of-contents)
   * [HW 16 Dockder-3](#hw-16-dockder-3)
      * [Основное задание](#Основное-задание)
      * [ДЗ * (Сетевые алиасы)](#ДЗ--Сетевые-алиасы)
      * [ДЗ ** (Сборка с alpine)](#ДЗ--Сборка-с-alpine)
      * [ДЗ *** (Ужать образ)](#ДЗ--Ужать-образ)
   * [HW 15 Docker-2](#hw-15-docker-2)
      * [Основное задание](#Основное-задание-1)
      * [ДЗ *](#ДЗ-)
   * [HW 14 Docker-1](#hw-14-docker-1)
      * [Основное задание](#Основное-задание-2)
      * [ДЗ *](#ДЗ--1)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)

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

В ДЗ ** у меня собран образ на без alpine, поэтому версия 3.0 #FIXME
```bash
docker kill $(docker ps -q) ;\
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest &&\
docker run -d --network=reddit --network-alias=post f3ex/post:1.0 &&\
docker run -d --network=reddit --network-alias=comment f3ex/comment:1.0 &&\
docker run -d --network=reddit -p 9292:9292 f3ex/ui:2.0
```

```bash
docker volume create reddit_db

docker kill $(docker ps -q) ;\
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db -v reddit_db:/data/db mongo:latest &&\
docker run -d --network=reddit --network-alias=post f3ex/post:1.0 &&\
docker run -d --network=reddit --network-alias=comment f3ex/comment:1.0 &&\
docker run -d --network=reddit -p 9292:9292 f3ex/ui:3.0
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
Образ занимает 205MB Мб, и то часть можно почистить. В ДЗ *** получилось уменьшить образ до 60 Мб 
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
