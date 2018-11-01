REGISTRY ?= docker.io
IMAGE    ?= bborbe/smtp
VERSION  ?= latest
VERSIONS = $(VERSION)

VERSIONS += $(shell git fetch --tags; git tag -l --points-at HEAD)

default: build

all: build upload clean

build:
	@tags=""; \
	for i in $(VERSIONS); do \
		tags="$$tags -t $(REGISTRY)/$(IMAGE):$$i"; \
	done; \
	echo "docker build --no-cache --rm=true $$tags ."; \
	docker build --no-cache --rm=true $$tags .

clean:
	@for i in $(VERSIONS); do \
		echo "docker rmi $(REGISTRY)/$(IMAGE):$$i"; \
		docker rmi $(REGISTRY)/$(IMAGE):$$i || true; \
	done

upload:
	@for i in $(VERSIONS); do \
		echo "docker push $(REGISTRY)/$(IMAGE):$$i"; \
		docker push $(REGISTRY)/$(IMAGE):$$i; \
	done

versions:
	@for i in $(VERSIONS); do echo $$i; done;

run:
	docker run \
	-p 25:25 \
	-p 587:587 \
	-e HOSTNAME=localhost.localdomain \
	-e RELAY_SMTP_SERVER=mail.benjamin-borbe.de \
	-e RELAY_SMTP_PORT=25 \
	-e ALLOWED_SENDER_DOMAINS="" \
	-e ALLOWED_NETWORKS="" \
	$(REGISTRY)/$(IMAGE):$(VERSION)

