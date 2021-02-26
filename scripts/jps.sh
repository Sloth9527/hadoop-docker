#/bin/bash

for node in 'master' 'slave1' 'slave2' 'slave3'
do
  echo "----------------hadoop-$node----------------"
  ssh "hadoop-$node" "source /etc/profile;/opt/jdk/bin/jps"
done
