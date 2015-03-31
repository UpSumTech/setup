FROM sumanmukherjee03/ubuntu:14.04
MAINTAINER Suman Mukherjee <sumanmukherjee03@gmail.com>

RUN apt-get -qq update \
  && apt-get install -y unzip

RUN cd /tmp \
  && wget --quiet https://dl.bintray.com/mitchellh/consul/0.5.0_linux_amd64.zip -O consul.zip \
  && unzip consul.zip \
  && chmod +x consul \
  && mv consul /usr/local/bin/consul

RUN mkdir /etc/consul.d

COPY configuration /etc/consul.d

ENV CONSUL_CONFIG /etc/consul.d

RUN mkdir -p /var/lib/consul

VOLUME ["/var/lib/consul"]

ENV CONSUL_DATA /var/lib/consul

EXPOSE 8300 8301 8302 8400 8500 53/udp

COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["consul", "agent", "-server"]
