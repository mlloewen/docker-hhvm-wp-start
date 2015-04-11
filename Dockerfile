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

# https://github.com/LearnBoost/stylus
# https://github.com/corysimmons/lost
# https://github.com/jenius/axis
# https://github.com/jenius/rupture
# https://github.com/jenius/autoprefixer-stylus
RUN npm install stylus lost-grid typographic rupture autoprefixer-stylus -g

RUN chown -R root:root /data/src/html/.
RUN chmod -R 747 /data/src/html

# create wordpress database
ADD mysqldbinit.sh /
RUN chmod 755 /
RUN /bin/bash /mysqldbinit.sh

# install some initial WP plugins and Themes
ADD wpinit.sh /
RUN /bin/bash /wpinit.sh

RUN apt-get clean

# Correct nginx path for wp permalinks	 
RUN sed -i -e"s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf
RUN sed -i -e"s/keepalive_timeout 2/keepalive_timeout 2;\n\tclient_max_body_size 100m/" /etc/nginx/nginx.conf
ADD default.conf /etc/nginx/sites-available/default
RUN /etc/init.d/nginx restart

# private expose
EXPOSE 80

CMD ["/sbin/my_init"]