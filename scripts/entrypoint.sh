#!/bin/bash

# ssh start
service ssh start

echo "YARN_PID_DIR: $YARN_PID_DIR"

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
    && sh jps.sh \
    && ssh hadoop-slave1 "cat /root/yarn_pid_dir/yarn--resourcemanager.pid" \
    && ssh hadoop-slave2 "source /etc/profile;sh -c \"/opt/hadoop/sbin/yarn-daemon.sh start resourcemanager\"" \
    && sh jps.sh
fi

echo "Start successfully"


if [[ -n $IMAGE_ROLE && $IMAGE_ROLE == "master" ]];
  then
    tail -f /opt/hadoop/logs/*.log
  else
    tail -f /dev/null
fi