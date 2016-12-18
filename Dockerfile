FROM alpine:3.4
MAINTAINER Benjamin Borbe <bborbe@rocketnews.de>

RUN apk add --update postfix ca-certificates supervisor rsyslog bash && rm -rf /var/cache/apk/*

COPY files/supervisord.conf /etc/supervisord.conf
COPY files/rsyslog.conf /etc/rsyslog.conf
COPY files/entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

EXPOSE 25 587

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
