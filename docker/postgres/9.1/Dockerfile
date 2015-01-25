FROM sumanmukherjee03/ubuntu:14.04
MAINTAINER Suman Mukherjee <sumanmukherjee03@gmail.com>

RUN groupadd -r postgres && useradd -r -g postgres postgres

RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list

RUN apt-get -qq update \
  && apt-get install -y \
    postgresql-common \
    postgresql-9.1 \
    postgresql-contrib-9.1 \
    postgresql-9.1-postgis \
    libpq-dev

RUN rm -rf /var/run/postgresql \
  && mkdir -p /var/run/postgresql \
  && chown -R postgres:postgres /var/run/postgresql

RUN rm -rf /var/lib/postgresql \
  && mkdir -p /var/lib/postgresql/data \
  && chown -R postgres:postgres /var/lib/postgresql

COPY configuration /etc/postgresql/

ENV PATH /usr/lib/postgresql/9.1/bin:$PATH
ENV PGDATA /var/lib/postgresql/data
ENV PGCONFIG /etc/postgresql

VOLUME ["/var/lib/postgresql/data"]

COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 5432
