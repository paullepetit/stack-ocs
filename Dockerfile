FROM debian

MAINTAINER @palle version: 1

RUN apt-get update

RUN apt-get -y install \
    apt-utils \
    apache2 \
    php5 \
    php5-gd \
    php5-mysql \
    perl \
    libxml-simple-perl \
    libdbi-perl \
    libapache-dbi-perl \
    libdbd-mysql-perl \
    libio-compress-perl \
    libxml-simple-perl \
    libsoap-lite-perl \
    libarchive-zip-perl \
    libnet-ip-perl \
    libphp-pclzip \
    libsoap-lite-perl \ 
    libarchive-zip-perl \
    htop \
    git \
    wget \
    tar \
    unzip \
    nano \
    make

RUN cpan -i XML::Entities

#Set time zone Europe/Paris
RUN cp /usr/share/zoneinfo/Europe/Paris /etc/localtime

#Set permission
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV POOLING enable
env APACHE_PID_FILE     /var/run/apache2.pid
env APACHE_RUN_DIR      /var/run/apache2
env APACHE_LOCK_DIR     /var/lock/apache2
env APACHE_LOG_DIR      /var/log/apache2

ADD apache2/vhost/default-ssl.conf /etc/apache2/sites-available

RUN /usr/sbin/a2dissite 000-default
RUN /usr/sbin/a2enmod rewrite
RUN /usr/sbin/a2ensite default-ssl
RUN /usr/sbin/a2enmod ssl

RUN echo "/usr/sbin/apache2ctl -D FOREGROUND" >> /root/run.sh && \
    chmod +x /root/run.sh
CMD ["/bin/bash", "/root/run.sh"]


RUN git clone https://github.com/OCSInventory-NG/OCSInventory-Server.git /tmp/ocs
RUN git clone https://github.com/OCSInventory-NG/OCSInventory-ocsreports.git /tmp/ocs/ocsreports

EXPOSE 443
EXPOSE 80
