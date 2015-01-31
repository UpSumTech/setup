FROM sumanmukherjee03/ubuntu:14.04
MAINTAINER Suman Mukherjee <sumanmukherjee03@gmail.com>

RUN apt-get -qq update \
  && apt-get install -y nginx

RUN rm -rf /etc/nginx \
  && mkdir -p /etc/nginx/vhosts

COPY configuration /etc/nginx/

RUN rm -rf /usr/src/app \
  && mkdir -p /usr/src/app \
  && chown -R www-data:www-data /usr/src/app

# RUN ln -sf /dev/stdout /var/log/nginx/access.log
# RUN ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80

CMD ["nginx"]
