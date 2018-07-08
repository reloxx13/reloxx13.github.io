#!/bin/bash
export TERM=xterm-256color

cpuTemp0=$(cat /sys/class/thermal/thermal_zone0/temp)
cpuTemp1=$(($cpuTemp0/1000))
cpuTemp2=$(($cpuTemp0/100))
cpuTempM=$(($cpuTemp2 % $cpuTemp1))

gpuTemp0=$(/opt/vc/bin/vcgencmd measure_temp)
gpuTemp0=${gpuTemp0//\'/º}
gpuTemp0=${gpuTemp0//temp=/}


# Basic info
HOSTNAME=`uname -n`
ROOT=`df -Ph | grep /dev/root | awk '{print $4}' | tr -d '\n'`

# System load
MEMORY1=`free -t -m | grep Total | awk '{print $3" MB";}'`
MEMORY2=`free -t -m | grep "Mem" | awk '{print $2" MB";}'`
LOAD1=`cat /proc/loadavg | awk {'print $1'}`
LOAD5=`cat /proc/loadavg | awk {'print $2'}`
LOAD15=`cat /proc/loadavg | awk {'print $3'}`

RUNNING=`ps ax | wc -l | tr -d " "`

upSeconds="$(/usr/bin/cut -d. -f1 /proc/uptime)"
secs=$((${upSeconds}%60))
mins=$((${upSeconds}/60%60))
hours=$((${upSeconds}/3600%24))
days=$((${upSeconds}/86400))
UPTIME=`printf "%d Days, %02d:%02d:%02dh" "$days" "$hours" "$mins" "$secs"`

LANIP=`ip a | grep "global eth0" | awk '{print $2}' | head -1 | cut -f1 -d/`
WLANIP=`ip a | grep "global wlan0" | awk '{print $2}' | head -1 | cut -f1 -d/`




echo "$(tput setaf 2)
   .~~.   .~~.    `date +"%A, %e %B %Y, %H:%M:%S"`
  '. \ ' ' / .'   `uname -srmo`$(tput setaf 1)
   .~ .~~~..~.    Hostname...........: $HOSTNAME
  : .~.'~'.~. :   Uptime.............: $UPTIME
 ~ (   ) (   ) ~  IP LAN.............: $LANIP
( : '~'.~.'~' : ) IP WLAN............: $WLANIP
 ~ .~ (   ) ~. ~  Running Processes..: $RUNNING
  (  : '~' :  )   CPU Temp...........: $cpuTemp1.$cpuTempM°C
   '~ .~~~. ~'    GPU Temp...........: $gpuTemp0
       '~'
==========================================================
 - Disk Space.........: $ROOT remaining
 - Memory used........: $MEMORY1 / $MEMORY2
 - Swap in use........: `free -m | tail -n 1 | awk '{print $3}'` MB
==========================================================
$(tput sgr0)"


