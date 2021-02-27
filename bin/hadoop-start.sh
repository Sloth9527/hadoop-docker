#/bin/bash

docker exec -it hadoopMaster bash -c "start-dfs.sh"

docker exec -it hadoopSlave1 bash -c "start-yarn.sh"
docker exec -it hadoopSlave2 bash -c "yarn-daemon.sh start resourcemanager"