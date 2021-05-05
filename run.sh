#!/bin/bash

#docker network create --subnet=172.66.0.0/24 bde-net
docker-compose -f docker-compose.yml up -d namenode hive-metastore-postgresql
docker-compose -f docker-compose.yml up -d datanode hive-metastore
docker-compose -f docker-compose.yml up -d resourcemanager
docker-compose -f docker-compose.yml up -d nodemanager
docker-compose -f docker-compose.yml up -d historyserver
sleep 3
docker-compose -f docker-compose.yml up -d hive-server
docker-compose -f docker-compose.yml up -d spark-master spark-worker
docker-compose -f docker-compose.yml up -d mysql-server
#docker-compose -f docker-compose.yml up -d elasticsearch
#docker-compose -f docker-compose.yml up -d kibana

echo "-------------------------------------"

my_ip=`ip route get 1|awk '{print $NF;exit}'`
echo "Namenode: http://${my_ip}:50070"
echo "Datanode: http://${my_ip}:50075"
echo "Spark-master: http://${my_ip}:8080"
docker-compose exec spark-master bash -c "./copy-jar.sh && exit"

