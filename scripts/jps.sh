#/bin/bash

echo "----------------hadoop-master----------------"
ssh hadoop-master "source /etc/profile;/opt/jdk/bin/jps"
echo "----------------hadoop-slave1----------------"
ssh hadoop-slave1 "source /etc/profile;/opt/jdk/bin/jps"
echo "----------------hadoop-slave2----------------"
ssh hadoop-slave2 "source /etc/profile;/opt/jdk/bin/jps"
echo "----------------hadoop-slave3----------------"
ssh hadoop-slave3 "source /etc/profile;/opt/jdk/bin/jps"
