#!/bin/bash
set -e
if [ -e "/root/is_not_first_time" ]; then
    exec "$@"
else
    /usr/local/bin/docker-entrypoint.sh rabbitmq-server -detached # 先按官方入口文件启动且是后台运行
    rabbitmqctl -n "$RABBITMQ_NODENAME@$RABBITMQ_HOSTNAME" stop_app # 停止应用
    rabbitmqctl -n "$RABBITMQ_NODENAME@$RABBITMQ_HOSTNAME" start_app # 启动应用
    rabbitmqctl set_policy ha-all "^" '{"ha-mode":"all"}'
    rabbitmqctl stop # 停止所有服务
    rabbitmq-plugins enable rabbitmq_management
    touch /root/is_not_first_time
    sleep 2s
    exec "$@"
fi

