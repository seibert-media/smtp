FROM alpine:3.8

LABEL maintainer="//SEIBERT/MEDIA GmbH  <docker@seibert-media.net>"
LABEL author="team-codeyard"
LABEL type="public"
LABEL versioning="subtag"

RUN apk add --update ca-certificates postfix supervisor rsyslog bash cyrus-sasl && rm -rf /var/cache/apk/*

COPY files/supervisord.conf /etc/supervisord.conf
COPY files/rsyslog.conf /etc/rsyslog.conf
COPY files/entrypoint.sh /usr/local/bin/entrypoint.sh

ENV HOSTNAME = ""
ENV RELAY_SMTP_SERVER = ""
ENV RELAY_SMTP_PORT = ""
ENV RELAY_SMTP_TLS = false
ENV RELAY_SMTP_USERNAME = ""
ENV RELAY_SMTP_PASSWORD = ""
ENV ALLOWED_NETWORKS = ""
ENV ALLOWED_SENDER_DOMAINS = ""
ENV SMTP_USERNAME = ""
ENV SMTP_PASSWORD = ""

EXPOSE 25 587

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["supervisord", "-c", "/etc/supervisord.conf"]
