#/bin/bash
echo "----------------hadoopMaster----------------"
docker exec -it hadoopMaster bash -c "start-dfs.sh"

echo "----------------hadoopSlave1----------------"
docker exec -it hadoopSlave1 bash -c "start-yarn.sh"
echo "----------------hadoopSlave2----------------"
docker exec -it hadoopSlave2 bash -c "yarn-daemon.sh start resourcemanager"