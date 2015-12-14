#!/bin/bash
set -e

find /home -type d  -name "vhost" -o -name "default"  -print0  | \
xargs -0 -I d find d -name "*.config" | \
xargs sed -i "/.*#SET PHP53_SERVER.*/{n;s/.*/fastcgi_pass $PHP53_SERVER;/}"

exec "$@"