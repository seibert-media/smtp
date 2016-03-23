default: build

clean:
	docker rmi bborbe/smtp

build:
	docker build --rm=true -t bborbe/smtp .

run:
	docker run -h example.com -p 25:25 -v /tmp:/smtp  bborbe/smtp:latest

bash:
	docker run -i -t bborbe/smtp:latest /bin/bash

upload:
	docker push bborbe/smtp
