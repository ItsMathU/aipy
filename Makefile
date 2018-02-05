AIPY_RELEASE ?= 1.0

REPO ?= docker.home.lab/
NS ?= aipy
NAME ?= ai-python-server
VERSION ?= ${AIPY_RELEASE}-1
IS_RELEASE = true

ifneq ($(http_proxy),)
DOCKER_FLAGS+=--build-arg 'http_proxy=$(http_proxy)'
endif
ifneq ($(https_proxy),)
DOCKER_FLAGS+=--build-arg 'https_proxy=$(https_proxy)'
endif
ifneq ($(HTTP_PROXY),)
DOCKER_FLAGS+=--build-arg 'HTTP_PROXY=$(HTTP_PROXY)'
endif
ifneq ($(HTTPS_PROXY),)
DOCKER_FLAGS+=--build-arg 'HTTPS_PROXY=$(HTTPS_PROXY)'
endif
ifneq ($(no_proxy),)
DOCKER_FLAGS+=--build-arg 'no_proxy=$(no_proxy)'
endif
ifneq ($(NO_PROXY),)
DOCKER_FLAGS+=--build-arg 'NO_PROXY=$(NO_PROXY)'
endif

DBUILD = docker build $(DOCKER_FLAGS)

ifneq ($(IS_RELEASE),true)
EXTRA_VERSION ?= snapshot-$(shell git rev-parse --short HEAD)
TAG=$(VERSION)-$(EXTRA_VERSION)
else
TAG=$(VERSION)
endif

OUTPUT = $(REPO)$(NS)/$(NAME):$(TAG)

all: docker

docker:
	$(DBUILD) -t $(OUTPUT) --build-arg AIPY_RELEASE=$(AIPY_RELEASE) .

install: docker
	docker push $(OUTPUT)

clean:
	-docker rmi $(OUTPUT)
