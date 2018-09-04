#!/bin/sh
touch /tmp/lr/starttime
date +'%Y%m%d%H%M%S' > /tmp/lr/starttime
cron &
nginx
