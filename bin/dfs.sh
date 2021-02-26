#/bin/bash

docker exec -it hadoop-master bash -c "hdfs dfs -$@"
