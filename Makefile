default: build

clean:
	docker rmi bborbe/smtp

build:
	docker build --no-cache --rm=true -t bborbe/smtp .

run:
	docker run -e HOSTNAME=localhost.localdomain -e RELAYHOST=mail.benjamin-borbe.de -e ALLOWED_SENDER_DOMAINS="" -e MYNETWORKS="" -p 25:25 bborbe/smtp:latest

shell:
	docker run -i -t bborbe/smtp:latest /bin/bash

upload:
	docker push bborbe/smtp





