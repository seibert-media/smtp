#!/bin/bash
set -e

opts=(
	dc_local_interfaces '0.0.0.0 ; ::0'
	dc_other_hostnames ''
	dc_relay_nets "$(ip addr show dev eth0 | awk '$1 == "inet" { print $2 }')"
	dc_eximconfig_configtype 'smarthost'
	dc_smarthost 'iredmail.mailfolder.org:25'
)

set-exim4-update-conf "${opts[@]}"

exec "$@"