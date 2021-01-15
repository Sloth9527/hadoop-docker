FROM ubuntu:18.04

# pre-installed package
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y wget

# open "https://www.oracle.com/java/technologies/javase-downloads.html", query "AuthParam" value
ARG AUTH_PARAM="1610620843_7631cdf4ceed6bf9727f6e53c74c40cc"

ENV JDK_VERSION="11.0.9" 
ENV JDK_FILE_NAME=jdk-${JDK_VERSION}_linux-x64_bin.tar.gz  
ENV JDK_URL=https://download.oracle.com/otn/java/jdk/${JDK_VERSION}+7/eec35ebefb3f4133bd045b891f05db94/${JDK_FILE_NAME}\?AuthParam\=${AUTH_PARAM}

# java env
ENV JAVA_HOME=/opt/jdk
ENV CLASSPATH=${JAVA_HOME}/lib
ENV PATH $JAVA_HOME/bin:$PATH

# install jdk
WORKDIR /opt

RUN wget --no-check-certificate -O ${JDK_FILE_NAME} -c --header "Cookie: oraclelicense=accept-securebackup-cookie" ${JDK_URL} \
    && tar -zxvf ${JDK_FILE_NAME} \
    && rm ${JDK_FILE_NAME} \
    && ln -s jdk-${JDK_VERSION} jdk \
    && echo "JAVA_HOME="${JAVA_HOME} \
    && java -version \
    && javac -version
