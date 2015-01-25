FROM sumanmukherjee03/ubuntu:14.04
MAINTAINER Suman Mukherjee <sumanmukherjee03@gmail.com>

RUN groupadd -r mysql && useradd -r -g mysql mysql

RUN apt-get -qq update \
  && curl -o mysql-5.7.deb -SL 'http://dev.mysql.com/get/mysql-apt-config_0.3.2-1ubuntu14.04_all.deb' \
  && dpkg -i mysql-5.7.deb

RUN apt-get -qq update \
  && apt-get install -y \
    mysql-server \
    libmysqlclient18 \
    mysql-client

RUN rm -rf /var/run/mysqld \
  && mkdir -p /var/run/mysqld \
  && chown -R mysql:mysql /var/run/mysqld

RUN rm -rf /var/lib/mysql \
  && mkdir -p /var/lib/mysql \
  && chown -R mysql:mysql /var/lib/mysql

RUN rm -rf /var/log/mysql \
  && mkdir -p /var/log/mysql \
  && chown -R mysql:mysql /var/log/mysql

COPY configuration/my.cnf /etc/mysql/my.cnf

ENV MYSQLDATA /var/lib/mysql
VOLUME ["/var/lib/mysql"]

COPY entrypoint.sh /entrypoint.sh
COPY ./initdb.d /initdb.d

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 3306
