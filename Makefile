REGISTRY ?= docker.io
ifeq ($(VERSION),)
	VERSION := $(shell git describe --tags `git rev-list --tags --max-count=1`)
endif

default: build

clean:
	docker rmi $(REGISTRY)/bborbe/smtp:$(VERSION)

build:
	docker build --no-cache --rm=true -t $(REGISTRY)/bborbe/smtp:$(VERSION) .

run:
	docker run \
	-p 25:25 \
	-p 587:587 \
	-e HOSTNAME=localhost.localdomain \
	-e RELAY_SMTP_SERVER=mail.benjamin-borbe.de \
	-e RELAY_SMTP_PORT=25 \
	-e ALLOWED_SENDER_DOMAINS="" \
	-e ALLOWED_NETWORKS="" \
	$(REGISTRY)/bborbe/smtp:$(VERSION)

shell:
	docker run -i -t $(REGISTRY)/bborbe/smtp:$(VERSION) /bin/bash

upload:
	docker push $(REGISTRY)/bborbe/smtp:$(VERSION)





