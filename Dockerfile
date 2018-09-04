# roulette-linux
# 
# Inspired by suicide-linux.
#

FROM ubuntu:latest

MAINTAINER Brett Bohnenkamper version: 1.0

COPY entrypoint.sh /etc/entrypoint.sh
COPY bash.bashrc /etc/
COPY crontab /etc/cron.d/roullete
COPY roulette.sh /tmp/roulette.sh

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y nginx cron dateutils && \
  echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
  chown -R www-data:www-data /var/lib/nginx && \
  chmod 0644 /etc/cron.d/roullete && \
  chmod 0777 /etc/entrypoint.sh && \
  chmod 0777 /tmp/roulette.sh && \
  crontab /etc/cron.d/roullete

VOLUME ["/tmp/lr"]

WORKDIR /etc/nginx

ENTRYPOINT ["/etc/entrypoint.sh"]
