FROM ubuntu:14.04
MAINTAINER Marc Seiler <mseiler@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:sjinks/phalcon && \
    apt-get update && \
    apt-get -y dist-upgrade

RUN apt-get -y install php5 \
                       php5-fpm \
                       php5-gd \
                       php-pear \
                       php5-mysql \
                       php5-mcrypt \
                       php5-xcache \
                       php5-xmlrpc \
                       php5-phalcon


RUN sed -i '/daemonize /c \
daemonize = no' /etc/php5/fpm/php-fpm.conf

RUN sed -i '/^listen /c \
listen = 0.0.0.0:9000' /etc/php5/fpm/pool.d/www.conf

RUN sed -i 's/^listen.allowed_clients/;listen.allowed_clients/' /etc/php5/fpm/pool.d/www.conf


ADD startup.sh /usr/sbin/startup.sh

WORKDIR /app/

EXPOSE 9000
VOLUME /app/site
ENTRYPOINT ["bash", "/usr/sbin/startup.sh"]
