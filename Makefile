USER_NAME = f3ex
VERSION = latest

.PHONY: build_ui build_comment build_post build_prometheus build_mongodb_exporter build_all  push_ui push_comment push_post push_prometheus push_mongodb_exporter push_blackbox_exporter push_all docker_restart docker_stop docker_start default


default: docker_restart

build_ui:
	cd src/ui && bash docker_build.sh

build_comment:
	cd src/comment && bash docker_build.sh

build_post:
	cd src/post-py && bash docker_build.sh

build_prometheus:
	docker build -t $(USER_NAME)/prometheus:$(VERSION) monitoring/prometheus

build_mongodb_exporter:
	docker build -t $(USER_NAME)/mongodb_exporter:$(VERSION) hw_21/mongodb_exporter

build_all: build_ui build_comment build_post build_prometheus build_mongodb_exporter

push_ui:
	docker push $(USER_NAME)/ui:$(VERSION)

push_comment:
	docker push $(USER_NAME)/comment:$(VERSION)

push_post:
	docker push $(USER_NAME)/post:$(VERSION)

push_prometheus:
	docker push $(USER_NAME)/prometheus:$(VERSION)

push_mongodb_exporter:
	docker push $(USER_NAME)/mongodb_exporter:$(VERSION)

push_all: push_ui push_comment push_post push_prometheus push_mongodb_exporter

docker_stop:
	cd docker && docker-compose down

docker_start:
	cd docker && docker-compose up -d

docker_restart:
	cd docker &&  docker-compose up -d --build
