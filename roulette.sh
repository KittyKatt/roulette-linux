#!/usr/bin/env bash

# Array of possible commands
declare -a command_list=(
  "uptime"
  "uptine"
  "printf 'hello'"
  "echo"
  "date"
  "cd"
  "du"
  "env"
  "locale"
  "id"
  "tail /var/log/lastlog"
  "head /var/log/lastlog"
  "whoami"
  "users"
)
# Set this to the full path to tally.txt
tally_loc=/tmp/tally
wipe_loc=/tmp/wipes

# Create files if not already created
if [ ! -e $tally_loc ]; then touch $tally_loc && echo "0" > $tally_loc; fi

#Initialize varibles
commandS_num=$(cat $tally_loc)
wipe_num=$(cat $wipe_loc)
[ -z ${wipe_num} ] && wipe_num="0"
startTime=$(cat /tmp/starttime)
nowTime=$(date +'%Y%m%d%H%M%S')
current_up=$(dateutils.ddiff -f '%d days, %H hours, %M minutes, %S seconds' -i '%Y%m%d%H%M%S' $startTime $nowTime)

# Get random array element
rand=$[$RANDOM % ${#command_list[@]}]

if ${command_list[$rand]}; then
  ((commandS_num++))
  echo $commandS_num > $tally_loc
  [ -f /var/www/html/index.html ] && rm /var/www/html/index.html
  echo "<h1>Welcome to Suicide Linux Russian Roulette!</h1>" > /var/www/html/index.html
  echo "<br /><ul>" >> /var/www/html/index.html
  echo "<li>Current system uptime: $current_up</li>" >> /var/www/html/index.html
  echo "<li>Current number of successful (correct) commands: $commandS_num</li>" >> /var/www/html/index.html
  echo "<li>Current number of times the system has been wiped: $wipe_num</li>" >> /var/www/html/index.html
  echo "</ul>" >> /var/www/html/index.html
else
  ((wipe_num++))
  echo $wipe_num > $wipe_loc
  kill $(pgrep nginx);
fi
