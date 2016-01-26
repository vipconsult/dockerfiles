#! /bin/sh
set -e

mkdir -p /config

CONFIG_FILE=/config/agent.json

echo "{"> $CONFIG_FILE

if [ -n "${CONSUL_advertise_addr}" ]; then
    echo  '"advertise_addr": "'"$CONSUL_advertise_addr"'",' >> $CONFIG_FILE
fi

if [ -n "${CONSUL_bind_addr}" ]; then
    echo  '"bind_addr": "'"$CONSUL_bind_addr"'",' >> $CONFIG_FILE
fi

if [ -n "${CONSUL_client_addr}" ]; then
    echo  '"client_addr": "'"$CONSUL_client_addr"'",' >> $CONFIG_FILE
fi

if [ -n "${CONSUL_log_level}" ]; then
    echo  '"log_level": "'"$CONSUL_log_level"'",' >> $CONFIG_FILE
fi

if [ -n "${CONSUL_ca_file}" ]; then
    echo  '
        "ca_file": "'"$CONSUL_ca_file"'",
        "cert_file": "'"$CONSUL_cert_file"'",
        "key_file": "'"$CONSUL_key_file"'",
        "verify_incoming": true,
        "verify_outgoing": true,
        "ports": {
            "http": -1,
            "https": 8500
        },
        ' >> $CONFIG_FILE
fi

echo '
        "data_dir": "/data",
        "leave_on_terminate": true,
        "ui_dir": "/ui",
        "server": true,
        "dns_config": {
            "allow_stale": true,
            "max_stale": "1s"
        }
    }' >> $CONFIG_FILE 

# avoid race condition where consul starts and the config file is not closed
sleep 0.5;

exec "$@"