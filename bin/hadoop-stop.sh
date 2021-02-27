#/bin/bash

echo "----------------hadoopSlave2----------------"
docker exec -it hadoopSlave2 bash -c "yarn-daemon.sh stop resourcemanager"
echo "----------------hadoopSlave1----------------"
docker exec -it hadoopSlave1 bash -c "stop-yarn.sh"

echo "----------------hadoopMaster----------------"
docker exec -it hadoopMaster bash -c "stop-dfs.sh"
