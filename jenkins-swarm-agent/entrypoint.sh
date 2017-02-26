#!/bin/sh
set -e

LABELS="${LABELS:-docker}"

java -jar swarm-client.jar -labels=$LABELS -name=docker-$(hostname) $(cat /run/secrets/jenkins)
