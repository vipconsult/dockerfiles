#!/bin/bash
set -e

if [ -n "${PHP53_SERVER}" ]; then
	find /home -type d  -name "vhost" -o -name "default"  -print0  | \
	xargs -0 -I d find d -name "*.config" | \
	xargs sed -i "/.*#SET PHP53_SERVER.*/{n;s/.*/fastcgi_pass $PHP53_SERVER;/}"
fi

if [ -n "${PHP5_SERVER}" ]; then
	find /home -type d  -name "vhost" -o -name "default"  -print0  | \
	xargs -0 -I d find d -name "*.config" | \
	xargs sed -i "/.*#SET PHP5_SERVER.*/{n;s/.*/fastcgi_pass $PHP5_SERVER;/}"
fi




exec "$@"