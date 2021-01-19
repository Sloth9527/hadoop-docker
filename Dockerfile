FROM jk9527/hadoop:jdk-8u271

# pre-installed package
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y rsync openssh-server wget \
    && ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa \
    && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

WORKDIR /opt

# hadoop env
ENV HADOOP_FILE_NAME="hadoop-2.10.1"
ENV HADOOP_NODE_PATH="/root/hdfs"
ENV HADOOP_HOME=/opt/hadoop
ENV PATH ${HADOOP_HOME}/sbin:${HADOOP_HOME}/bin:${PATH}

# install hadoop
RUN wget -O ${HADOOP_FILE_NAME}.tar.gz "https://mirror.bit.edu.cn/apache/hadoop/common/${HADOOP_FILE_NAME}/${HADOOP_FILE_NAME}.tar.gz" \
    && tar -xzvf ${HADOOP_FILE_NAME}.tar.gz \
    && rm ${HADOOP_FILE_NAME}.tar.gz \
    && mv ${HADOOP_FILE_NAME} hadoop \
    && echo "HADOOP_HOME="${HADOOP_HOME} \
    && hadoop version

# init node dir
RUN mkdir -p ~/hdfs/namenode \ 
    && mkdir -p ~/hdfs/datanode \
    && mkdir $HADOOP_HOME/logs 

# backup conf
# RUN cp -r ${HADOOP_HOME}/etc/hadoop /opt/conf_backup \
#     && tar -czvf conf_backup.tar.gz ./conf_backup \
#     && rm -r ./conf_backup

# set config
COPY conf ./conf
COPY scripts ./scripts

RUN mv ./conf/ssh_config /etc/ssh/ssh_config \
    && rm -r $HADOOP_HOME/etc/hadoop \
    && mv -f ./conf $HADOOP_HOME/etc/hadoop

ENTRYPOINT ["/bin/bash", "./scripts/entrypoint.sh"]
