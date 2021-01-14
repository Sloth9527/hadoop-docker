FROM jk9527/hadoop:jdk-11.0.9

# pre-installed package
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y ssh rsync \
    && ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa

WORKDIR /opt

# hadoop env
ENV HADOOP_VERSION="2.10.1"
ENV HADOOP_DIR="hadoop-${HADOOP_VERSION}"
ENV HADOOP_URL="https://mirror.bit.edu.cn/apache/hadoop/common/${HADOOP_DIR}/${HADOOP_DIR}.tar.gz"

ENV HADOOP_HOME=/opt/${HADOOP_DIR}
ENV PATH ${HADOOP_HOME}/bin:${PATH}

# install hadoop

RUN wget ${HADOOP_URL} \
    && tar -xzvf ${HADOOP_DIR}.tar.gz \
    && rm ${HADOOP_DIR}.tar.gz \
    && hadoop version
