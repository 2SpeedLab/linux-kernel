## Tools for benmark
```
perf
netstat
ss
ethtool
wrk
```

## Perf
Apply config sysctl and running command perf testing performance link public server testing perf [iperf](https://iperf.fr/iperf-servers.php) and link command [ref](https://iperf.fr/iperf-doc.php#tuningudp) 

## ethtool

increase queue of network using cpu

default queue network server usually using 512 or something 256 if hardware support can increase queue network using max queue ring network support for high performance
```
ethtool -g em1      #comamnd list 
Ring parameters for em1:
Pre-set maximums:
RX:             4096
RX Mini:        0
RX Jumbo:       0
TX:             4096
Current hardware settings:
RX:             512
RX Mini:        0
RX Jumbo:       0
TX:             512
```

check current network server using command cat /proc/softirqs or ps aux | grep ksoftirq if high queue network using command below is will be most suitable

[what is ring buffer?](https://docs.kernel.org/userspace-api/perf_ring_buffer.html)

/proc/net/softnet_stat & /proc/net/sockstat
Before we continue, let’s discuss about /proc/net/softnet_stat & /proc/net/sockstat as these files will be used a lot then.
```
cat /proc/net/softnet_stat

0000272d 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
000034d9 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000001
00002c83 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000002
0000313d 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000003
00003015 00000000 00000001 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000004
000362d2 00000000 000000d2 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000005
```
Each line of the softnet_stat file represents a CPU core starting from CPU0.
The statistics in each column are provided in hexadecimal
1st column is the number of frames received by the interrupt handler.
2nd column is the number of frames dropped due to netdev_max_backlog being exceeded.
3rd column is the number of times ksoftirqd ran out of netdev_budget or CPU time when there was still work to be done.