FROM ubuntu:18.04

# pre-installed package
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y wget

# open "https://www.oracle.com/java/technologies/javase-downloads.html", query "AuthParam" value
ARG AUTH_PARAM="1610974153_93ce63bf51ff2e7e6853b5e7b3ba2bac"

ENV JDK_VERSION="8u271" 
ENV JDK_FILE_NAME=jdk-${JDK_VERSION}-linux-x64.tar.gz
ENV JDK_URL=https://download.oracle.com/otn/java/jdk/${JDK_VERSION}-b09/61ae65e088624f5aaa0b1d2d801acb16/${JDK_FILE_NAME}\?AuthParam\=${AUTH_PARAM}

# java env
ENV JAVA_HOME=/opt/jdk
ENV PATH $JAVA_HOME/bin:$PATH

# install jdk
WORKDIR /opt

RUN wget --no-check-certificate -O ${JDK_FILE_NAME} -c --header "Cookie: oraclelicense=accept-securebackup-cookie" ${JDK_URL} \
    && tar -zxvf ${JDK_FILE_NAME} \
    && rm ${JDK_FILE_NAME} \
    && mv jdk1.8.0_271 jdk \
    && echo "JAVA_HOME="${JAVA_HOME} \
    && java -version \
    && javac -version
