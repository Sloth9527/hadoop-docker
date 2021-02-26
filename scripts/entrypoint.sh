#!/bin/bash

# ssh start
service ssh start

if [[ -z $IMAGE_ROLE || $IMAGE_ROLE != "master" ]];
  then
    echo "Start zookeeper_id_$ZOO_MY_ID ..."
    echo $ZOO_MY_ID > /root/zk_data/myid
    zkServer.sh start
fi

# write slaves file with SLAVES env
if [[ -n $IMAGE_ROLE && $IMAGE_ROLE == "master" ]];
  then
    echo "Start write slaves file..."
    echo $SLAVES > /opt/hadoop/etc/hadoop/slaves
    sed -i "s/ /\n/g" /opt/hadoop/etc/hadoop/slaves
    echo "cat /opt/hadoop/etc/hadoop/slaves :"
    cat /opt/hadoop/etc/hadoop/slaves
    echo "Write slaves file successfully"
fi

# format node && start hdfs
if [[ -n $IMAGE_ROLE && $IMAGE_ROLE == "master" ]];
  then
    echo "Start hdfs..."
    start-dfs.sh \
    && echo "Start yarn..." \
    && ssh hadoop-slave1 "source /etc/profile;sh -c \"/opt/hadoop/sbin/start-yarn.sh\"" \
    && ssh hadoop-slave2 "source /etc/profile;sh -c \"/opt/hadoop/sbin/yarn-daemon.sh start resourcemanager\""
fi

echo "Start successfully"

tail -f /dev/null
