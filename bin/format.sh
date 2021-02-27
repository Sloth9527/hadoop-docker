#/bin/bash

for node in 'Slave1' 'Slave2' 'Slave3'
do
  echo "----------------hadoop$node jps----------------"
  docker exec -it "hadoop$node" bash -c "source /etc/profile;hadoop-daemon.sh start journalnode"
done

echo "----------------hadoopMaster----------------"
docker exec -it hadoopMaster bash -c "hdfs namenode -format"
docker exec -it hadoopMaster bash -c "hadoop-daemon.sh start namenode"

echo "----------------hadoopSlave3----------------"
docker exec -it hadoopSlave3 bash -c "hdfs namenode -bootstrapStandby"

echo "----------------hadoopMaster----------------"
docker exec -it hadoopMaster bash -c "hdfs zkfc -formatZK"

docker exec -it hadoopMaster bash -c "hadoop-daemon.sh stop namenode"

for node in 'Slave1' 'Slave2' 'Slave3'
do
  echo "----------------hadoop$node jps----------------"
  docker exec -it "hadoop$node" bash -c "source /etc/profile;hadoop-daemon.sh stop journalnode"
done
