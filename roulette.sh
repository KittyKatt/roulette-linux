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
tally_loc=/tmp/lr/tally.txt

# Create files if not already created
if [ ! -e $tally_loc ]; then touch $tally_loc && printf "0\n0\n" > $tally_loc; fi

#Initialize varibles
commandS_num=$(awk '{print $1}' $tally_loc)
wipe_num=$(awk '{print $2}' $tally_loc)
startTime=$(cat /tmp/lr/starttime)
nowTime=$(date +'%Y%m%d%H%M%S')
current_up=$(dateutils.ddiff -f '%d days, %H hours, %M minutes, %S seconds' -i '%Y%m%d%H%M%S' $startTime $nowTime)

# Get random array element
rand=$[$RANDOM % ${#command_list[@]}]

# update_tally function
function update_tally() {
  if [ "$1" == "wipe" ]; then
    ((wipe_num++))
    echo "0 $wipe_num" > $tally_loc
  elif [ "$1" == "tally" ]; then
    ((commandS_num++))
    echo "$commandS_num $wipe_num" > $tally_loc
  else
    :
  fi
}

if ${command_list[$rand]}; then
  update_tally tally
  rm /var/www/html/index.html
  echo "<h1>Welcome to Suicide Linux Russian Roulette!</h1>" > /var/www/html/index.html
  echo "<br /><ul>" >> /var/www/html/index.html
  echo "<li>Current system uptime: $current_up</li>" >> /var/www/html/index.html
  echo "<li>Current number of successful (correct) commands: $commandS_num</li>" >> /var/www/html/index.html
  echo "<li>Current number times the system has been wiped: $wipe_num</li>" >> /var/www/html/index.html
  echo "</ul>" >> /var/www/html/index.html
else
  update_tally wipe
  kill -9 $(pgrep nginx);
fi
