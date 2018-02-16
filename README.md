# Aleksey Stepanenko

Table of Contents
=================

   * [Aleksey Stepanenko](#aleksey-stepanenko)
   * [Table of Contents](#table-of-contents)
   * [HW 19 Docker-6](#hw-19-docker-6)
      * [ДЗ * (Авто регистрация Runner)](#ДЗ--Авто-регистрация-runner)
      * [ДЗ ** (Нотификация в слак)](#ДЗ--Нотификация-в-слак)
   * [HW 17 Docker-4](#hw-17-docker-4)
      * [Основное задание](#Основное-задание)
      * [ДЗ ** (Bridge network driver)](#ДЗ--bridge-network-driver)
      * [HW 17 ДЗ***](#hw-17-ДЗ)
      * [17 ДЗ**** (Override)](#17-ДЗ-override)
   * [HW 16 Dockder-3](#hw-16-dockder-3)
      * [Основное задание](#Основное-задание-1)
      * [ДЗ * (Сетевые алиасы)](#ДЗ--Сетевые-алиасы)
      * [ДЗ ** (Сборка с alpine)](#ДЗ--Сборка-с-alpine)
      * [ДЗ *** (Ужать образ)](#ДЗ--Ужать-образ)
   * [HW 15 Docker-2](#hw-15-docker-2)
      * [Основное задание](#Основное-задание-2)
      * [ДЗ *](#ДЗ-)
   * [HW 14 Docker-1](#hw-14-docker-1)
      * [Основное задание](#Основное-задание-3)
      * [ДЗ *](#ДЗ--1)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)

# HW 20 Docker-7

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



# HW 19 Docker-6

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
