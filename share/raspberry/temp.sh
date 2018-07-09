#!/bin/bash
cpuTemp0=$(cat /sys/class/thermal/thermal_zone0/temp)
cpuTemp1=$(($cpuTemp0/1000))
cpuTemp2=$(($cpuTemp0/100))
cpuTempM=$(($cpuTemp2 % $cpuTemp1))

gpuTemp0=$(/opt/vc/bin/vcgencmd measure_temp)
gpuTemp0=${gpuTemp0//\'/º}
gpuTemp0=${gpuTemp0//temp=/}

freq=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq)
echo CPU Freq: $freq"MHz"
echo CPU Temp: $cpuTemp1"."$cpuTempM"ºC"
echo GPU Temp: $gpuTemp0
