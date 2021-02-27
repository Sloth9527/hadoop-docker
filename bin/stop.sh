#/bin/bash

docker exec -it hadoopSlave2 bash -c "yarn-daemon.sh stop resourcemanager" \
&& docker exec -it hadoopSlave1 bash -c "stop-yarn.sh" \
&& docker exec -it hadoopMaster bash -c "stop-dfs.sh"

for i in {1..3}
do
  docker exec -it "hadoopSlave$i" bash -c "zkServer.sh stop"
done

docker-compose -f docker-compose.yml down
