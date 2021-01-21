# IDEA 连接 hadoop 集群

## **连接集群**
### **准备**

- idea
- hadoop 集群
- java

### **1. 创建 Maven 项目**

打开 file -> new -> project, 选择 maven.

### **2. 修改 pom.xml**

1. 添加 properties

   ```
     <properties>
       <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
       <maven.compiler.source>11</maven.compiler.source>
       <maven.compiler.target>11</maven.compiler.target>
     </properties>
   ```

2. 添加 apache repository:

    ```
      <repositories>
       <repository>
         <id>apache</id>
         <url>http://maven.apache.org</url>
       </repository>
      </repositories>

    ```

3. 添加hadoop依赖:

   - hadoop-common
   - hadoop-hdfs
   - hadoop-mapreduce-client-core
   - hadoop-mapreduce-client-jobclient
   - log4j

   ```
    <dependency>
      <groupId>org.apache.hadoop</groupId>
      <artifactId>hadoop-common</artifactId>
      <version>2.10.1</version>
    </dependency>
    <dependency>
      <groupId>org.apache.hadoop</groupId>
      <artifactId>hadoop-hdfs</artifactId>
      <version>2.10.1</version>
    </dependency>
    <dependency>
      <groupId>org.apache.hadoop</groupId>
      <artifactId>hadoop-mapreduce-client-core</artifactId>
      <version>2.10.1</version>
    </dependency>
    <dependency>
      <groupId>log4j</groupId>
      <artifactId>log4j</artifactId>
      <version>1.2.17</version>
    </dependency>
    <dependency>
      <groupId>org.apache.hadoop</groupId>
      <artifactId>hadoop-mapreduce-client-jobclient</artifactId>
      <version>2.10.1</version>
    </dependency>
   ```

### **3. 添加 Resources**

将下列 hadoop 配置文件添加到 resources 文件夹下

  - core-site.xml (如果是本地docker容器将host改为localhost)
  - hdfs-site.xml
  - log4j.properties

### **4. 创建 WordCount.class**

将 [hadoop wordcount 例子](https://hadoop.apache.org/docs/current/hadoop-mapreduce-client/hadoop-mapreduce-client-core/MapReduceTutorial.html) 复制进来

将要计算的文本上传到hadoop集群

```
  hadoop fs -copyFromLocal ./word.txt /wordcount/input/word.txt
```

### **5. 设置 run 参数**

打开菜单 Run -> Edit Configurations -> Application -> WordCount

在 Program arguments 中添加 wordcount 需要的输入文件和输出位置

```
  Program arguments:hdfs://localhost:9000/wordcount/input/word.txt hdfs://localhost:9000/wordcount/output
```
  - 在默认的验证模式下,如果有权限问题可以在 Environment variables 添加环境变量, 将本机的userName修改为容器中的userName

```
  Environment variables:HADOOP_USER_NAME=root
```

### **6. Run WordCount**

执行 Run -> Run 'WordCount', 进入集群查看结果

```
root@d833b1c4e30b:/opt# hadoop fs -cat /wordcount/output/part-r-00000
hadoop  1
hello   1
world   2
```

## **异常问题记录**

### **1. java:不支持发行版本5**

在 `pom.xml` 修改 source 与 target 为1.5以上的版本

```
   <properties>
     <maven.compiler.source>11</maven.compiler.source>
     <maven.compiler.target>11</maven.compiler.target>
   </properties>
```

### **2. Permission denied 没有权限问题**

当idea提交任务给 Hadoop 时候遇到下面异常:

```
  org.apache.hadoop.security.AccessControlException:Permission denied: user=u1, access=WRITE, inode="/matrix":root:root:drwxr-xr-x
```

从报错信息里面分析,本地用户 u1 去写 ```/matrix``` 文件夹时候,因为只有root用户才拥有写的权限而被拒绝. 

最粗暴的方法可以 `hadoop fs -chmod 777 /matrix` 命令将 `/matrix` 文件夹的权限改为 `drwxrwxrwx` 让所有的用户都拥有写的权限

或者更改hadoop配置, 关闭文件权限

```
  # hdfs-site.xml
  <property>
    <name>dfs.permissions</name>
    <value>false</value>
  </property>
```

翻看源码在获取用户的时候是在 `org.apache.hadoop.security.UserGroupInformation` 中通过 `getCurrentUser()` 方法获取, 代码如下:

```
public static synchronized UserGroupInformation getCurrentUser() throws IOException {
    AccessControlContext context = AccessController.getContext();
    Subject subject = Subject.getSubject(context);
    return subject != null && !subject.getPrincipals(User.class).isEmpty() ? new UserGroupInformation(subject) : getLoginUser();
  }
```

通过打点判断 `currentUser` 是通过 `getLoginUser()` 获得的,查看源码发现这个是一个简单的单例模式, `loginUser` 是由 `loginUserFromSubject()` 方法生成, 从中找到 `loginUser` 是可以通过环境变量 `HADOOP_PROXY_USER` 创建一个 `proxyUser` 代替 `realUser`

```
  public static synchronized void loginUserFromSubject(Subject subject) throws IOException {
    ensureInitialized();

    try {
      if (subject == null) {
        subject = new Subject();
      }

      LoginContext login = newLoginContext(authenticationMethod.getLoginAppName(), subject, new UserGroupInformation.HadoopConfiguration());
      login.login();
      LOG.debug("Assuming keytab is managed externally since logged in from subject.");
      UserGroupInformation realUser = new UserGroupInformation(subject, true);
      realUser.setLogin(login);
      realUser.setAuthenticationMethod(authenticationMethod);
      String proxyUser = System.getenv("HADOOP_PROXY_USER");
      if (proxyUser == null) {
        proxyUser = System.getProperty("HADOOP_PROXY_USER");
      }

      loginUser = proxyUser == null ? realUser : createProxyUser(proxyUser, realUser);
      
      ...
  }

```

在 IDEA 中打开 Run -> edit configurations ,选中要执行的 application 在 Environment variables 中添加环境变量 `HADOOP_PROXY_USER=root` ,并 core-site.xml 中配置 proxyuser

```
   <property>
      <name>hadoop.proxyuser.jk.hosts</name>
      <value>*</value>
   </property>
   <property>
      <name>hadoop.proxyuser.jk.users</name>
      <value>root,hdfs</value>
   </property>
```

或者直接修改 realUser 为容器中的 user ,无需修改 hadoop 配置,在 Environment variables 中添加环境变量 `HADOOP_USER_NAME=root` 即可.
