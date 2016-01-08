FROM sumanmukherjee03/rails:onbuild-4.2.5
MAINTAINER Suman Mukherjee

USER webapp

RUN source /.bash_profile \
  && gem install passenger

RUN cp /opt/app/current/config/database.example.yml /opt/app/current/config/database.yml

RUN source /.bash_profile \
  && cd /opt/app/current \
  && bundle install

CMD source /.bash_profile \
  && cd /opt/app/current \
  && bundle exec rake db:drop \
  && bundle exec rake db:create \
  && bundle exec rake db:migrate \
  && passenger start \
    --port 3000 \
    --user webapp \
    --pid-file /var/run/app/passenger.pid \
    --log-file /var/log/app/passenger.3000.log
