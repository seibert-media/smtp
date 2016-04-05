FROM ubuntu:14.04
MAINTAINER Benjamin Borbe <bborbe@rocketnews.de>
ENV HOME /root
ENV LANG en_US.UTF-8
RUN locale-gen en_US.UTF-8

RUN set -x \
	&& apt-get update --quiet \
	&& apt-get upgrade --quiet --yes \
	&& apt-get install --quiet --yes --no-install-recommends postfix supervisor bsd-mailx \
	&& apt-get autoremove --yes \
	&& apt-get clean

ADD postfix.conf /etc/supervisor/conf.d/
RUN newaliases

EXPOSE 25

ADD entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD supervisord --nodaemon -c /etc/supervisor/supervisord.conf
