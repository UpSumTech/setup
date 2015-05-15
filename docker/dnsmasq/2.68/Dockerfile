FROM sumanmukherjee03/ubuntu:14.04
MAINTAINER Suman Mukherjee <sumanmukherjee03@gmail.com>

ENV MYSQL_VERSION 5.7

RUN apt-get -qq update \
  && apt-get install -y dnsmasq

COPY configuration/dnsmasq.conf /etc/dnsmasq.conf

VOLUME ["/etc/dnsmasq.d"]

EXPOSE 53 53/udp

CMD ["dnsmasq", "--no-daemon", "--conf-dir=/etc/dnsmasq.d"]
