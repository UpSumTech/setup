FROM sumanmukherjee03/ubuntu:14.04
MAINTAINER Suman Mukherjee <sumanmukherjee03@gmail.com>

RUN apt-get -qq update \
  && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7

RUN apt-get install -y apt-transport-https
RUN apt-get install -y ca-certificates

RUN echo "deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main" > /etc/apt/sources.list.d/passenger.list

RUN apt-get -qq update \
  && apt-get install -y \
    nginx-extras \
    passenger

RUN rm -rf /etc/nginx \
  && mkdir -p /etc/nginx/vhosts

RUN rm -rf /usr/src/app \
  && mkdir -p /usr/src/app \
  && chown -R www-data:www-data /usr/src/app

COPY ./entrypoint.sh /entrypoint.sh

COPY configuration/nginx.conf /etc/nginx/

RUN rm -rf /usr/src/vhost_templates \
  && mkdir -p /usr/src/vhost_templates

COPY configuration/vhost_templates /usr/src/vhost_templates

EXPOSE 80

RUN mkdir -p /var/lib/nginx \
  && chown -R www-data:www-data /var/lib/nginx \
  && mkdir -p /var/log/nginx \
  && chown -R www-data:www-data /var/log/nginx

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx"]
