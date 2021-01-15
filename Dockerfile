FROM jk9527/hadoop:jdk-11.0.9

# pre-installed package
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y rsync openssh-server wget \
    && ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa \
    && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

WORKDIR /opt

# hadoop env
ENV HADOOP_FILE_NAME="hadoop-2.10.1"
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

RUN ls -al 
