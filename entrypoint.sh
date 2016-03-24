#!/bin/bash
set -e

smtp_host=${SMTP_HOST:-'iredmail.mailfolder.org'}
smtp_port=${SMTP_PORT:-'25'}

opts=(
	dc_local_interfaces '0.0.0.0 ; ::0'
	dc_other_hostnames ''
	dc_relay_nets "10.101.0.0/16:10.102.0.0/16:$(ip addr show dev eth0 | awk '$1 == "inet" { print $2 }')"
	dc_eximconfig_configtype 'smarthost'
	dc_smarthost "${smtp_host}:${smtp_port}"
	dc_relay_domains ''
)

set-exim4-update-conf "${opts[@]}"

exec "$@"