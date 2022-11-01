#!/bin/sh
SYSINFO=$(uname -snrvpo)
CPU=$(cat /proc/cpuinfo | grep "physical id" | sort -u | wc -l)
VCPU=$(cat /proc/cpuinfo | grep "^processor" | wc -l)
RAM_USED=$(free | grep "Mem" | awk '{print int($3 / 1000 + 0.5)}')
RAM_TOTAL=$(free | grep "Mem" | awk '{print int($2 / 1000 + 0.5)}')
RAM_PCT=$(free | grep "Mem" | awk '{print int($3/$2 * 1000 + 0.5)/10}')
DISK_USED=$(df -h / | grep "/" | awk '{print $3}' | tr -d '[[:alpha:]]')
DISK_TOTAL=$(df -h / | grep "/" | awk '{print $2}' | tr -d '[[:alpha:]]')
DISK_PCT=$(df -h / | grep "/" | awk '{print $5}')
CPU_PCT=$(top -bn 1 -i | grep "%Cpu" | awk '{print $2}')
LAST_BOOT=$(who | awk '{print $3, $4}' | head -1)
LVM=$(df | grep "/dev/mapper" | wc -l)
LVM_CHECK=$(if [ $LVM -eq 0 ]; then echo no; else echo yes; fi)
TCP_ACTIVE=$(netstat -ant | grep "ESTABLISHED" | wc -l)
USER_COUNT=$(who | awk '{print $1}' | sort -u | wc -l)
IP=$(hostname -I | awk '{print $1}')
MAC=$(ip -o link | grep "state UP" | awk '{print $(NF - 2)}')
SUDO_COUNT=$(journalctl _COMM=sudo | grep "COMMAND" | wc -l)

wall -n "#Architecture: ${SYSINFO}
#CPU Physical: ${CPU}
#vCPU: ${VCPU}
#Memory Usage: ${RAM_USED}/${RAM_TOTAL}MB (${RAM_PCT}%)
#Disk Usage: ${DISK_USED}/${DISK_TOTAL}GB (${DISK_PCT})
#CPU Load: ${CPU_PCT}%
#Last Boot: ${LAST_BOOT}
#LVM Use: ${LVM_CHECK}
#Connections TCP: ${TCP_ACTIVE} ESTABLISHED
#User Log: ${USER_COUNT}
#Network: IP ${IP} (${MAC})
#Sudo: ${SUDO_COUNT} cmd"