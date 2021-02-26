#/bin/bash

docker exec -it hadoop-slave2 bash -c "yarn-daemon.sh stop resourcemanager" \
&& docker exec -it hadoop-slave1 bash -c "stop-yarn.sh" \
&& docker exec -it hadoop-master bash -c "stop-dfs.sh" \
&& docker-compose -f docker-compose.yml down
