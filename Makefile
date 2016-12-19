default: build

clean:
	docker rmi bborbe/smtp

build:
	docker build --no-cache --rm=true -t bborbe/smtp .

run:
	docker run \
	-p 25:25 \
	-p 587:587 \
	-e HOSTNAME=localhost.localdomain \
	-e RELAY_SMTP_SERVER=mail.benjamin-borbe.de \
	-e RELAY_SMTP_PORT=25 \
	-e ALLOWED_SENDER_DOMAINS="" \
	-e ALLOWED_NETWORKS="" \
	bborbe/smtp:latest

shell:
	docker run -i -t bborbe/smtp:latest /bin/bash

upload:
	docker push bborbe/smtp





