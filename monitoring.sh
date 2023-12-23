#Architecture: Linux wil 4.19.0-16-amd64 #1 SMP Debian 4.19.181-1 (2021-03-19) x86_64 GNU/Linux
arch=$(uname -a)

#CPU physical : 1
ncpu=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)

#vCPU : 1
nvcpu=$(grep "processor" /proc/cpuinfo | sort | uniq | wc -l)

#Memory Usage: 74/987MB (7.50%)
mem_total=$(free -m | awk '/Mem:/{print $2}')
mem_used=$(free -m | awk '/Mem:/{print $3}')
mem_p=$(free | awk '/Mem:/{printf("%.2f%%"), $3 / $2 * 100}')

#Disk Usage: 1009/2Gb (49%)
disk_total=$(df -h --total | awk '/total/{print $2}')
disk_used=$(df -h --total | awk '/total/{print $3}')
disk_p=$(df -h --total | awk '/total/{print $5}')

#CPU load: 6.7%
cpu=$(top -bn1 | grep 'Cpu(s)' | sed 's/,/ /g' | awk '{printf("%.1f%%"), 100 - $8}')

#Last boot: 2021-04-25 14:45
boot=$(uptime -s)

#LVM use: yes
lvm=$(if [ "$(lsblk | grep lvm | wc -l)" -eq 0 ]; then echo no; else echo yes; fi)

#Connections TCP : 1 ESTABLISHED
tcp=$(ss -t | grep ESTAB | wc -l)

#User log: 1
ulog=$(who | wc -l)

#Network: IP 10.0.2.15 (08:00:27:51:9b:a5)
ip=$(hostname -I)
mac=$(ip link show | grep ether | awk '{print $2}')

#Sudo : 42 cmd"
sudo=$(grep COMMAND /var/log/sudo/sudo.log | wc -l)

wall "
#Architecture: $arch
#CPU physical : $ncpu
#vCPU : $nvcpu
#Memory Usage: $mem_used/${mem_total}MB ($mem_p)
#Disk Usage: ${disk_used}B/${disk_total}B ($disk_p)
#CPU load: $cpu
#Last boot: $boot
#LVM use: $lvm
#Connections TCP : $tcp ESTABLISHED
#User log: $ulog
#Network: IP $ip ($mac)
#Sudo : $sudo cmd"