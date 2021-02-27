#/bin/bash

sh hadoop-stop.sh

sh zk-stop.sh

docker-compose -f docker-compose.yml down
