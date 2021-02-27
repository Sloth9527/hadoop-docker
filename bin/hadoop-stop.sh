#/bin/bash

docker exec -it hadoopSlave2 bash -c "yarn-daemon.sh stop resourcemanager"
docker exec -it hadoopSlave1 bash -c "stop-yarn.sh"

docker exec -it hadoopMaster bash -c "stop-dfs.sh"
