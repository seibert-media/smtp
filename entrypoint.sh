#!/bin/bash
set -e

SMTP_HOST=${SMTP_HOST:-'iredmail.mailfolder.org'}
SMTP_PORT=${SMTP_PORT:-'25'}
SERVER_HOSTNAME=${SERVER_HOSTNAME:-'smtp.default.svc.cluster.local'}
DOMAIN=${DOMAIN:-'default.svc.cluster.local'}

#Comment default mydestination, we will set it bellow
sed -i -e '/mydestination/ s/^#*/#/' /etc/postfix/main.cf
sed -i -e 's/inet_interfaces = localhost/inet_interfaces = all/g' /etc/postfix/main.cf

echo "myhostname=${SERVER_HOSTNAME}"  >> /etc/postfix/main.cf
echo "mydomain=${DOMAIN}"  >> /etc/postfix/main.cf
echo 'mydestination=$myhostname'  >> /etc/postfix/main.cf
echo 'myorigin=$mydomain'  >> /etc/postfix/main.cf
echo "relayhost = [$SMTP_HOST]:${SMTP_PORT}" >> /etc/postfix/main.cf

exec "$@"