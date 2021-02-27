#/bin/bash

for node in 'Master' 'Slave1' 'Slave2' 'Slave3'
do
  echo "----------------hadoop-$node----------------"
  ssh "hadoop$node" "source /etc/profile;/opt/jdk/bin/jps"
done
