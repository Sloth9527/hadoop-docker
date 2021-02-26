#/bin/bash

docker exec -it hadoop-slave2 bash -c "yarn-daemon.sh stop resourcemanager" \
&& docker exec -it hadoop-slave1 bash -c "stop-yarn.sh" \
&& docker exec -it hadoop-master bash -c "stop-dfs.sh"

for i in {1..3}
do
  docker exec -it "hadoop-slave$i" bash -c "zkServer.sh stop"
done

docker-compose -f docker-compose.yml down
