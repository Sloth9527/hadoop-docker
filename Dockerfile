FROM jk9527/hadoop:jdk-11.0.9

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
RUN mkdir -p ~/hdfs/namenode && \ 
    mkdir -p ~/hdfs/datanode && \
    mkdir $HADOOP_HOME/logs

# set config
COPY conf ./conf
COPY scripts ./scripts

RUN mv ./conf/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml \
    && mv ./conf/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml \
    && mv ./conf/hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh \
    && mv ./conf/mapred-site.xml.template $HADOOP_HOME/etc/hadoop/mapred-site.xml.template \
    && mv ./conf/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml \
    && mv ./conf/ssh_config /etc/ssh/ssh_config \
    && rm -r conf

ENTRYPOINT ["/bin/bash", "./scripts/entrypoint.sh"]
