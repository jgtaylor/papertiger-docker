#!/bin/bash

NET="pta-net"
DATA=~/docker-data
[[ -d ${DATA} ]] || mkdir ~/docker-data
[[ -d ${DATA}/influxdb ]] || mkdir ${DATA}/influxdb
[[ -d ${DATA}/grafana ]] || mkdir ${DATA}/grafana
[[ -d ${DATA}/nodered ]] || mkdir ${DATA}/nodered

# create docker network for papertiger
docker network create --driver bridge ${NET}

# create influxdb docker container --defaults to port 8086
docker run -dit -v ${DATA}/influxdb:/var/lib/influxdb -e "INFLUXDB_DB=papertiger" --name influxdb --network ${NET} influxdb:alpine

# create grafana --defaults to port 3000
docker run -dit -P -v ${DATA}/grafana:/var/lib/grafana -e "GF_INSTALL_PLUGINS=briangann-gauge-panel,natel-discrete-panel,vonage-status-panel" --name grafana --network ${NET} grafana/grafana

# create node-red --defaults to port 1880
docker run -dit -P -v ${DATA}/nodered:/data --name nodered --network ${NET} nodered/node-red-docker:slim-v8

# create Nginx and mount it's config file.
# /grafana should proxy to grafana:3000
# /nodered should proxy to nodered:1880

#TODO: need the nginx conf file.
