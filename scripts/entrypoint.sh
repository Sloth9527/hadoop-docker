#!/bin/bash

# ssh start
service ssh start

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
        if [ ! -d /root/hdfs/namenode/current ];
            then
                echo "Namenode is not formatted!"
                echo "Start format namenode..."
                hdfs namenode -format \
                && echo "Formatted successfully" \
                && echo "Start hdfs..." \
                && start-dfs.sh \
                && start-yarn.sh
            else
                echo "Start hdfs..."
                start-dfs.sh \
                && start-yarn.sh
        fi
fi

echo "Start successfully"

tail -f /dev/null
