FROM jk9527/hadoop:jdk-8u271

# pre-installed package
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y rsync openssh-server wget \
    && ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa \
    && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

WORKDIR /opt
USER root

# hadoop env
ENV HADOOP_FILE_NAME="hadoop-2.10.1"
ENV HADOOP_NODE_PATH="/root/hdfs"
ENV HADOOP_HOME=/opt/hadoop
ENV PATH ${HADOOP_HOME}/sbin:${HADOOP_HOME}/bin:${PATH}
ENV YARN_PID_DIR=/root/yarn_pid_dir

# install hadoop
RUN wget -O ${HADOOP_FILE_NAME}.tar.gz "https://downloads.apache.org/hadoop/common/${HADOOP_FILE_NAME}/${HADOOP_FILE_NAME}.tar.gz" \
# RUN wget -O ${HADOOP_FILE_NAME}.tar.gz "https://apache.claz.org/hadoop/common/${HADOOP_FILE_NAME}/${HADOOP_FILE_NAME}.tar.gz" \
    && tar -xzvf ${HADOOP_FILE_NAME}.tar.gz \
    && rm ${HADOOP_FILE_NAME}.tar.gz \
    && mv ${HADOOP_FILE_NAME} hadoop

# init node dir
RUN mkdir -p ~/hdfs/namenode \ 
    && mkdir -p ~/hdfs/datanode \
    && mkdir $HADOOP_HOME/logs \
    && mkdir $YARN_PID_DIR

# backup conf
# RUN cp -r ${HADOOP_HOME}/etc/hadoop /opt/conf_backup \
#     && tar -czvf conf_backup.tar.gz ./conf_backup \
#     && rm -r ./conf_backup

# install zookeeper
ENV ZOOKEEPER_HOME=/opt/zookeeper
ENV PATH ${ZOOKEEPER_HOME}/bin:${PATH}

RUN wget https://downloads.apache.org/zookeeper/zookeeper-3.6.2/apache-zookeeper-3.6.2-bin.tar.gz \
# RUN wget https://apache.claz.org/zookeeper/zookeeper-3.6.2/apache-zookeeper-3.6.2-bin.tar.gz \
    && tar -xzvf apache-zookeeper-3.6.2-bin.tar.gz \
    && rm apache-zookeeper-3.6.2-bin.tar.gz \
    && mv apache-zookeeper-3.6.2-bin zookeeper

# set config
COPY conf/ssh/ssh_config /etc/ssh/ssh_config
COPY scripts ./scripts

EXPOSE 2181 2888 3888 8080

ENTRYPOINT ["/bin/bash", "./scripts/entrypoint.sh"]
