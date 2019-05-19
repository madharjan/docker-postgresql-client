
NAME = madharjan/docker-postgresql-client
VERSION = 9.5

DEBUG ?= true

DOCKER_USERNAME ?= $(shell read -p "DockerHub Username: " pwd; echo $$pwd)
DOCKER_PASSWORD ?= $(shell stty -echo; read -p "DockerHub Password: " pwd; stty echo; echo $$pwd)
DOCKER_LOGIN ?= $(shell cat ~/.docker/config.json | grep "docker.io" | wc -l)

.PHONY: all build run test stop clean tag_latest release clean_images

all: build

docker_login:
ifeq ($(DOCKER_LOGIN), 1)
		@echo "Already login to DockerHub"
else
		@docker login -u $(DOCKER_USERNAME) -p $(DOCKER_PASSWORD)
endif

build:
	docker build \
		--build-arg POSTGRESQL_VERSION=$(VERSION) \
		--build-arg VCS_REF=`git rev-parse --short HEAD` \
		--build-arg DEBUG=${DEBUG} \
		-t $(NAME):$(VERSION) --rm .

run:
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi

	docker run -d \
		-e POSTGRESQL_DATABASE=mydb \
		-e POSTGRESQL_USERNAME=myuser \
		-e POSTGRESQL_PASSWORD=mypass \
		-e DEBUG=${DEBUG} \
		--name postgresql_client madharjan/docker-postgresql:9.5
		sleep 2

test:
	sleep 5
	./bats/bin/bats test/tests.bats

stop:
	docker exec postgresql_client /bin/bash -c "sv stop postgresql" 2> /dev/null || true
	sleep 4
	docker stop postgresql_client 2> /dev/null || true

clean: stop
	docker rm postgresql_client 2> /dev/null || true
	docker images | grep "<none>" | awk '{print$3 }' | xargs docker rmi 2> /dev/null || true

publish: docker_login run test clean
	docker push $(NAME)

tag_latest:
	docker tag $(NAME):$(VERSION) $(NAME):latest

release: docker_login  run test clean tag_latest
	docker push $(NAME)

clean_images: clean
	docker rmi $(NAME):latest $(NAME):$(VERSION) 2> /dev/null || true
	docker logout 


