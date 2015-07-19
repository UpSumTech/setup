FROM sumanmukherjee03/node:v0.12.7
MAINTAINER Suman Mukherjee <sumanmukherjee03@gmail.com>

RUN mkdir -p /opt/app/

EXPOSE 8989

# This is a hack
RUN usermod -u 1000 webapp
RUN usermod -G staff webapp

ONBUILD COPY . /opt/app/current

ONBUILD RUN chown -R webapp:webapp /opt/app

ONBUILD USER webapp

ONBUILD WORKDIR /opt/app/current

ONBUILD RUN ls -al /opt/app/current

ONBUILD VOLUME ["/opt/app/current"]
