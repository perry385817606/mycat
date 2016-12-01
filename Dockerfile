# build java 8, tomcat 7 ,php ,mysql+mycat

FROM 192.168.100.221:5000/centos7:2

MAINTAINER perry 385817606@qq.com 

WORKDIR /root

# configure mysql yum repo
RUN  echo '[mysql56-community]' > /etc/yum.repos.d/mysql-community.repo
RUN  echo 'name=MySQL 5.6 Community Server' >> /etc/yum.repos.d/mysql-community.repo
RUN  echo 'baseurl=http://repo.mysql.com/yum/mysql-5.6-community/el/7/$basearch/' >> /etc/yum.repos.d/mysql-community.repo
RUN  echo 'enabled=1' >> /etc/yum.repos.d/mysql-community.repo
RUN  echo 'gpgcheck=0' >> /etc/yum.repos.d/mysql-community.repo

# install java,http,php,mysql
RUN yum  -y install java-1.8.0-openjdk wget httpd php php-mysqlnd mysql-community*

# initialized mysql db
RUN mysql_install_db --user=mysql

ENV MYSQL_ROOT_PASSWORD=123456
ENV MYCAT_USER mycat
ENV MYCAT_PASS mycat

# install tomcat
#RUN wget http://apache.opencas.org/tomcat/tomcat-7/v7.0.67/bin/apache-tomcat-7.0.67.tar.gz
COPY apache-tomcat-7.0.67.tar.gz /root/
RUN tar xvf /root/apache-tomcat-7.0.67.tar.gz -C /usr/local/ && mv /usr/local/apache-tomcat-7.0.67/ /usr/local/tomcat
#RUN wget http://code.taobao.org/svn/openclouddb/downloads/old/MyCat-Sever-1.2/Mycat-server-1.2-GA-linux.tar.gz
COPY Mycat-server-1.2-GA-linux.tar.gz /root/
RUN mkdir /usr/local/mycat && tar xvf /root/Mycat-server-1.2-GA-linux.tar.gz -C /usr/local/mycat && useradd mycat && \
    chown -R mycat.mycat /usr/local/mycat && chmod a+x /usr/local/mycat/bin/*

RUN yum clean all

EXPOSE 8080 8066 9066
COPY startup.sh /root/startup.sh
RUN chmod a+x /root/startup.sh
ENTRYPOINT /root/startup.sh


