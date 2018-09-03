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
tally_loc=/tmp/tally.txt

# Create files if not already created
if [ ! -e $tally_loc ]; then touch $tally_loc && echo "0" > $tally_loc; fi

#Initialize varibles
commandS_num=$(cat $tally_loc)
startTime=$(cat /tmp/starttime)
nowTime=$(date +'%Y%m%d%H%M%S')
current_up=$(dateutils.ddiff -f '%d days, %H hours, %M minutes, %S seconds' -i '%Y%m%d%H%M%S' $startTime $nowTime)

# Use shuf to pick random command from the list of possible commands
#command="$(shuf -n1 ${command_list[@]})"
# Get random array element
rand=$[$RANDOM % ${#command_list[@]}]

if ${command_list[$rand]}; then
  ((commandS_num++))
  echo $commandS_num > $tally_loc
  echo "<h1>Welcome to Suicide Linux Russian Roulette!</h1>" > /var/www/html/index.html
  echo "<br /><ul>" >> /var/www/html/index.html
  echo "<li>Current system uptime: $current_up</li>" >> /var/www/html/index.html
  echo "<li>Current number of successful (correct) commands: $(cat $tally_loc)</li>" >> /var/www/html/index.html
  echo "</ul>" >> /var/www/html/index.html
else
  # The command from above was bad. Killing the container by killing the webserver.
  kill -9 $(pgrep nginx);
fi
