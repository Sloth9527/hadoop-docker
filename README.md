# **hadoop-docker**

## **前言**

本项目使用 docker-compose 在单机上快速搭建  hadoop 集群，方便基于 hadoop 的开发与测试.

## **快速启动**

### **1. 准备**

本地需要提前安装 [docker](https://docs.docker.com/engine/install/) && [docker-compose](https://docs.docker.com/compose/install/)

### **2. 创建 [docker-compose.yml](docker-compose.yml)**

hadoop 容器将分为 master 和 slave 两个类型, 其中 master 容器中运行 namenode 和 ResourceManager, slave 容器中运行 datanode 和 NodeManager.

容器将在 ../hdfs_data 位置存储 namenode 和 datanode

#### **hadoop-master 容器配置参数**

- namenode 文件夹地址:

   ```
     /root/hdfs/namenode
   ```

- environment

    - IMAGE_ROLE
      
        容器默认为 slave 容器,当 IMAGE_ROLE 标记为 master 表示此容器为master容器，根据此标记容器启动时候自动执行 format namenod && start-dfs && start-yarn 等命令

    - SLAVES

        此值将覆盖 [etc/hadoop/slaves](https://hadoop.apache.org/docs/r2.10.1/hadoop-project-dist/hadoop-common/ClusterSetup.html) 文件， 每个host需要用空格分开:

        ```
          slave1 slave2 slave3
        ```

- depends_on

    将 slave 容器添加到 master 容器依赖

- docker-compose.yml:

  ```
    hadoop-master:
      container_name: hadoop-master
      image: jk9527/hadoop:2.10.1
      environment:
        IMAGE_ROLE: master
        SLAVES: "hadoop-slave1 hadoop-slave2 hadoop-slave3"
      ports: 
        - 8088:8088
        - 50070:50070
      volumes:
        - ../hdfs_data/namenode:/root/hdfs/namenode
      networks:
        - hadoop
      depends_on:
        - hadoop-slave1
        - hadoop-slave2
        - hadoop-slave3
  ```

#### **hadoop-slave 容器配置参数**

- datanode 文件夹地址:

   ```
     /root/hdfs/datanode
   ```

- docker-compose.yml:

  ```
    hadoop-slave1:
      container_name: hadoop-slave1
      image: jk9527/hadoop:2.10.1
      volumes:
        - ../hdfs_data/datanode/slave1:/root/hdfs/datanode
      networks:
        - hadoop
  ```

### **3. 拉取镜像**

```
  docker-compose -f docker-compose.yml pull
```

如果无法下载镜像或者速度太慢可选择 [本地构建镜像](#本地构建镜像)

### **4. 容器启动**

1. 启动

   ```
     docker-compose -f docker-compose.yml up -d
   ```

2. 进入容器

   ```
     docker exec -it hadoop-master bash
   ```
3. 查看 jps

    master 容器

   ```
      root@82cfc6f195ed:/opt# jps
      1142 ResourceManager
      135 NameNode
      361 SecondaryNameNode
      1243 Jps
   ```
    slave 容器

   ```
      root@9a052552ecba:/opt# jps
      291 NodeManager
      44 DataNode
      463 Jps
   ```

### **5. 停止容器**

```
  docker-compose -f docker-compose.yml down
```

## **IDEA 链接 Hadoop 容器**

- [ ] TODO 教程

### **1. 创建一个 Maven 项目**

### **2. 添加 Dependency**

### **3. 添加 Resources**

### **4. 添加 Resources**

## **本地构建镜像**

### **1. clone 项目到本地**

### **2. 构建 JDK 镜像** (如果有其他JDK镜像此步骤可跳过)

1. 构建jdk镜像需要登陆 [Oracle](https://www.oracle.com/java/technologies/javase-downloads.html) 帐号, 获取下载 8u271 版本的 authParam.

2. 开始构建：

   ```
    docker build -f ./JDK/8u271/Dockerfile -t hadoop:jdk-8u271  --build-arg AUTH_PARAM=1610788919_1582412e6f81f833b06686828d7664bf . 
   ```

### **3. 构建 Hadoop 镜像** 

1. 如果有其他 JDK 镜像, 则将 DockerFile 修改为其他 JDK 镜像 tag

   ```
     FROM hadoop:jdk-8u271
   ```

2. 如需修改hadoop配置，进入 [conf](./conf) 文件夹修改配置

3. 开始构建:

   ```
     docker build -t hadoop:2.10.1 .
   ```

### **3. 修改 docker-compose.yml**

将所有容器的 image 都修改为本地镜像 tag

```
   services:
     hadoop-master:
       container_name: hadoop-master
       image: hadoop:2.10.1
```
