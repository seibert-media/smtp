FROM ubuntu:14.04
MAINTAINER Benjamin Borbe <bborbe@rocketnews.de>
ENV HOME /root
ENV LANG en_US.UTF-8
RUN locale-gen en_US.UTF-8

RUN set -x \
    && apt-get update --quiet \
    && apt-get install --quiet --yes --no-install-recommends postfix supervisor bsd-mailx \
    && apt-get clean

ADD entrypoint.sh /usr/local/bin/
ADD postfix.conf /etc/supervisor/conf.d/
RUN newaliases

ENTRYPOINT ["entrypoint.sh"]

EXPOSE 25

CMD supervisord --nodaemon -c /etc/supervisor/supervisord.conf
