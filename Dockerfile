# linux-roullete
# 
# Inspired by suicide-linux by tiagoad.
#

FROM ubuntu:latest

MAINTAINER Brett Bohnenkamper version: 0.1-A

# COPY start-roullete.sh /start-roullete.sh
COPY entrypoint.sh /etc/entrypoint.sh
COPY bash.bashrc /etc/
COPY crontab /etc/cron.d/roullete
COPY roulette.sh /tmp/roulette.sh
COPY commands.txt /tmp/commands.txt
# RUN /bin/bash /start-roullete.sh

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y nginx cron dateutils && \
  echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
  chown -R www-data:www-data /var/lib/nginx && \
  chmod 0644 /etc/cron.d/roullete && \
  chmod 0777 /etc/entrypoint.sh && \
  chmod 0777 /tmp/roulette.sh && \
  chmod 0777 /tmp/commands.txt && \
  crontab /etc/cron.d/roullete

VOLUME ["/var/www/html"]

WORKDIR /etc/nginx

EXPOSE 80

ENTRYPOINT ["/etc/entrypoint.sh"]
