#!/bin/sh
touch /tmp/starttime
date +'%Y%m%d%H%M%S' > /tmp/starttime
cron &
nginx
