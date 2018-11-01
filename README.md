# SMTP

Smtp server and relay.

## Run

```
docker run \
-p 25:25 \
-p 587:587 \
-e HOSTNAME=localhost.localdomain \
-e RELAY_SMTP_SERVER=mail.benjamin-borbe.de \
-e RELAY_SMTP_PORT=25 \
-e ALLOWED_SENDER_DOMAINS="" \
-e ALLOWED_NETWORKS="" \
bborbe/smtp:1.1.0
```
