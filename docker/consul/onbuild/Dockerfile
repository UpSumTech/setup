FROM sumanmukherjee03/consul:0.5.0
MAINTAINER Suman Mukherjee <sumanmukherjee03@gmail.com>

ONBUILD COPY ./healthcheck-setup.sh /healthcheck-setup.sh
ONBUILD RUN ["/bin/bash", "/healthcheck-setup.sh"]

ONBUILD ADD ./healthcheck /usr/local/bin
ONBUILD ADD ./configuration /etc/consul.d
