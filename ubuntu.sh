#!/bin/bash

# ubuntu16.04

#id
#
#if [ "$(id -u)" != "0" ]; then
#	echo "This script must be run as root" 1>&2
#	exit 1
#fi

REPO="deb http://repo.yandex.ru/clickhouse/deb/stable/ main/"
VERSION="1.1.54385"
#VERSION=\*

# install ClickHouse
sudo apt-get update && \
sudo apt-get install -y apt-transport-https && \
sudo mkdir -p /etc/apt/sources.list.d && \
echo $REPO | sudo tee /etc/apt/sources.list.d/clickhouse.list && \
sudo apt-get update && \
sudo apt-get install --allow-unauthenticated -y clickhouse-server=$VERSION clickhouse-client=$VERSION && \
sudo apt-get install -y ssh && \
sudo rm -rf /var/lib/apt/lists/* /var/cache/debconf && \
sudo apt-get clean

# setup ClickHouse to listen on 127.0.0.1:9000
sudo sed -i 's,<tcp_port>9000</tcp_port>,<tcp_port>9000</tcp_port><listen_host>0.0.0.0</listen_host>,' /etc/clickhouse-server/config.xml && \
sudo sed -i 's,<listen_host>::1</listen_host>,,' /etc/clickhouse-server/config.xml

#echo 'root:root' | chpasswd
#sed -i 's,PermitRootLogin prohibit-password,PermitRootLogin yes,' /etc/ssh/sshd_config

sudo chown -R clickhouse /etc/clickhouse-server/

# ports used by ClickHouse: 9000 8123 9009

#CLICKHOUSE_CONFIG="/etc/clickhouse-server/config.xml"

sudo service clickhouse-server restart
#/etc/init.d/ssh restart && service clickhouse-server restart
#CMD /etc/init.d/ssh start && /usr/bin/clickhouse-server --config=${CLICKHOUSE_CONFIG}
#ENTRYPOINT exec /usr/bin/clickhouse-server --config=${CLICKHOUSE_CONFIG}
