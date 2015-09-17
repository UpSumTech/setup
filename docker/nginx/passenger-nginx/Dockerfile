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

RUN mkdir -p /etc/nginx/vhosts

COPY configuration/nginx.conf /etc/nginx/

EXPOSE 80

RUN mkdir -p /var/lib/nginx \
  && chown -R www-data:www-data /var/lib/nginx \
  && mkdir -p /var/log/nginx \
  && chown -R www-data:www-data /var/log/nginx

CMD ["nginx"]
