FROM abegodong/docker-hhvm-for-wordpress

RUN apt-get update && apt-get -y upgrade

# add repo mariaDB
RUN \
   apt-get install software-properties-common && \
   apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db && \
   add-apt-repository 'deb http://mariadb.mirror.rafal.ca//repo/10.0/ubuntu trusty main'

# install MariaDB
RUN  apt-get update && apt-get install -y mariadb-server pwgen
RUN mkdir /etc/service/mysql
ADD mysqlstart.sh /etc/service/mysql/run

# install NodeJS
RUN curl -sL https://deb.nodesource.com/setup | sudo bash -
RUN apt-get install -y nodejs
RUN npm install stylus nib jeet -g

RUN chown -R www-data:www-data /data/src/html
RUN chmod -R 747 /data/src/html

# create wordpress database
ADD ./start.sh /start.sh
RUN chmod 755 /start.sh
RUN /bin/bash /start.sh

# private expose
EXPOSE 80

CMD ["/sbin/my_init"]