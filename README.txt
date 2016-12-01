# cat startup.sh 
#!/bin/bash
sed -i 's/user name="test"/user name=\"'"$MYCAT_USER"'"/' /usr/local/mycat/conf/server.xml
sed -i 's/name="password">test/name="password">'"$MYCAT_PASS"'/' /usr/local/mycat/conf/server.xml
mysqld_safe & /usr/local/mycat/bin/mycat start & httpd & /usr/local/tomcat/bin/catalina.sh run


startup.sh 和Dockerfile在同一个目录下

验证如下：

1.基于Docker生成镜像
# docker build -t demo/mycat:v1 .

2.查看生成的镜像
# docker images

3.运行容器
# docker run --name=mycat -d -p 8080:8080 -p 9066:9066 -p 8066:8066 -p 81:80 demo/mycat:v1

验证tomcat是否启动
http://192.168.3.211:8080

验证apache是否启动
http://192.168.3.211:81

验证mycat是否能正常使用  
[root@host10 docker]# mysql -umycat -pmycat -h192.168.3.221 -P8066 -DTESTDB
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MySQL connection id is 3
Server version: 5.1.48-mycat-1.2 MyCat Server (OpenCloundDB)

Copyright (c) 2000, 2015, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MySQL [TESTDB]> 
MySQL [TESTDB]> 

[root@host10 docker]# mysql -umycat -pmycat -h192.168.3.221 -P9066 -DTESTDB
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MySQL connection id is 0
Server version: 5.1.48-mycat-1.2 CobarManager@Alibaba

Copyright (c) 2000, 2015, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MySQL [TESTDB]> 