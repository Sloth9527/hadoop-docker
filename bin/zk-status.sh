#/bin/bash

for node in 'Slave1' 'Slave2' 'Slave3'
do
  echo "----------------hadoop$node zkServer----------------"
  docker exec -it "hadoop$node" bash -c "source /etc/profile;zkServer.sh status"
done
