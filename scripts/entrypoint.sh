#!/bin/bash

service ssh start

# format node && start hdfs
if [[ -n $1 && $1 == "master" ]];
    then
        if [ ! -d /root/hdfs/namenode/current ];
            then
                echo "Namenode is not formatted!"
                echo "Start format namenode..."
                hdfs namenode -format \
                && echo "Formatted successfully" \
                && echo "Start hdfs..." \
                && start-dfs.sh
            else
                echo "Start hdfs..."
                start-dfs.sh
        fi
fi

echo "Start successfully"

tail -f /dev/null
