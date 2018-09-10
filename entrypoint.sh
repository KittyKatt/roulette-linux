#!/bin/sh
touch /tmp/rl/starttime
date +'%Y%m%d%H%M%S' > /tmp/rl/starttime
cron &
nginx
