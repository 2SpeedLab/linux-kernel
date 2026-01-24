[cen](https://indico.cern.ch/event/274974/contributions/620868/attachments/497313/687046/RV_Network_ALICE_WKS_20140307_v0.pdf)

[LVS: Performance and Kernel Tuning](https://docs.huihoo.com/hpc-cluster/linux-virtual-server/HOWTO/LVS-HOWTO.performance.html)

[network](https://www.opensourceforu.com/2016/10/network-performance-monitoring/)

[Linux Advanced Routing & Traffic Control HOWTO](https://tldp.org/HOWTO/Adv-Routing-HOWTO/lartc.kernel.obscure.html)

[How passively monitor for tcp packet loss? (Linux)](https://serverfault.com/questions/318909/how-passively-monitor-for-tcp-packet-loss-linux)

[Troubleshooting SYNs to LISTEN sockets dropped message from netstat](http://www.linux-admins.net/2020/08/troubleshooting-syns-to-listen-sockets.html)

[Monitoring and Tuning the Linux Networking Stack: Sending Data](https://blog.packagecloud.io/monitoring-tuning-linux-networking-stack-sending-data/)

[Extreme HTTP Performance Tuning: 1.2M API req/s on a 4 vCPU EC2 Instance](https://talawah.io/blog/extreme-http-performance-tuning-one-point-two-million/)

[Low latency tuning guide](https://rigtorp.se/low-latency-guide/)

[disk+network](https://www.geeksforgeeks.org/linux-unix/linux-kernel-optimization/)

[book](https://dokumen.pub/performance-tuning-for-linux-servers-013144753x-9780131447530.html)

[network linux in kernel](https://dokumen.pub/performance-tuning-for-linux-servers-013144753x-9780131447530.html)

[atlantislinux](https://atlanticlinux.ie/training/performance-tuning/slides-with-notes.pdf)

[have tunning panic](https://www.enginyring.com/en/blog/a-guide-to-tuning-kernel-parameters-with-sysctl-in-linux)

[Maximizing TCP Throughput in Linux: Understanding and Tuning Send and Receive Buffers](https://madflojo.medium.com/maximizing-tcp-throughput-in-linux-understanding-and-tuning-send-and-receive-buffers-92df654c415f)

[What exactly does Kernel parameters do ?](https://community.unix.com/t/what-exactly-does-kernel-parameters-do/330689)

[google-cloud](https://lpc.events/event/16/contributions/1343/attachments/1027/1972/Tuning%20Linux%20TCP%20for%20data-center%20networks%20(3).pdf)

[Linux Tuning For SIP Routers – Part 4 (Networking)](https://voipmagazine.wordpress.com/2014/12/29/linux-tuning-for-sip-routers-part-4-networking/)

[https://voipmagazine.wordpress.com/2014/12/29/linux-tuning-for-sip-routers-part-4-networking/](https://nixsanctuary.com/linux-network-performance-optimization-tips-for-optimizing-linux-network-throughput-and-latency/)

[study](https://flashcards.world/flashcards/sets/a2986fc9-ed31-4456-8e88-6d001128e5c6/)

[explain parameters](https://www.golinuxcloud.com/sysctl-config-for-high-performance-servers/)

[windows size](https://cromwell-intl.com/open-source/performance-tuning/tcp.html)

[Sysctl Configuration for High Performance Servers](https://www.golinuxcloud.com/sysctl-config-for-high-performance-servers/)

[Account for the Bandwidth-Delay Product with Larger Network Buffers](https://lonesysadmin.net/2013/12/19/account-bandwidth-delay-product-larger-network-buffers/)

[congestion control tcp ](https://lowendtalk.com/discussion/184195/linux-network-performance-tuning)

[Intel 10Gb x520-da2 Performance Tuning for Linux ](https://glenewhittenberg.blogspot.com/2016/03/intel-x520-da2-performance-tuning-for.html)

[TCP Implementation in Linux: A Brief Tutorial](https://sn0rt.github.io/media/paper/TCPlinux.pdf)

[Recent Linux TCP Updates, and how to tune your 100G host](https://scinet.supercomputing.org/community/documents/36/sc16-techtalk01-100G-Tuning-INDIS.tierney.pdf)
[dpdk](https://fast.dpdk.org/doc/perf/DPDK_21_11_Mellanox_NIC_performance_report.pdf)

[Understanding NUMA Node for Performance Benchmarks](https://enterprise-support.nvidia.com/s/article/understanding-numa-node-for-performance-benchmarks)

[nvidia How to Tune Your Linux Server for Best Performance Using the mlnx_tune Tool](https://enterprise-support.nvidia.com/s/article/How-to-Tune-Your-Linux-Server-for-Best-Performance-Using-the-mlnx-tune-Tool)

[www.mellanox.com Performance Tuning Guidelines for Mellanox Network Adapters](https://ebooks.hgs.name/Performance_Tuning_Guide_for_Mellanox_Network_Adapters.pdf)
[fasterdata](https://fasterdata.es.net/host-tuning/linux/100g-tuning/)

[rhel tunning](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/monitoring_and_managing_system_status_and_performance/tuning-the-network-performance_monitoring-and-managing-system-status-and-performance#increasing-the-ring-buffers-to-reduce-a-high-packet-drop-rate_tuning-network-adapter-settings)

[someone share](https://gist.github.com/gburd/6f555a7b1197260d8472e24a35b7752c)

[https://cherusk.github.io/](https://cherusk.github.io/)

[Tune TCP ](https://cromwell-intl.com/open-source/performance-tuning/tcp.html)

[low latency guide](https://rigtorp.se/low-latency-guide/)

```
https://cherusk.github.io/linux-tcp-window-scaling-quantification-rmemwmem.html
https://cherusk.github.io/monitoring-and-tuning-the-linux-networking-stack-egress-tx.html
```

search

### Low latency network tuning
```
IRQ Processing
The irqbalance daemon is a system utility that optimizes CPU usage by balancing interrupt loads across multiple CPUs. It identifies the most active interrupt sources and assigns them to a single unique CPU, thereby spreading the workload and minimizing cache rate misses for interrupt handlers. This helps to balance CPU load and improve overall system performance.

To run irqbalance, use the irqbalance --oneshot command with the --debug3 flag if necessary.
```

### TCP max tw buckets
```
The kernel parameter controls the maximum number of TCP time-wait (tw) buckets allowed in the system. A tw bucket is used to store information about a closed TCP connection. If the number of tw buckets exceeds this limit, the system will start dropping new incoming connections. This parameter helps prevent a Denial of Service (DoS) attack by limiting the number of tw buckets. The default value is 262144.
```

### TCP Congestion Control
```
Congestion control is the TCP protocol's method of managing data flow over a network and preventing congestion - queuing delay, packet loss or blocking new connections.

TCP supports several congestion algorithms, to enable each of them you need to load the module. The default is the Reno algorithm, the Cubic and BBR are also available. The algorithms available in your kernel can be checked with the next command: sysctl net.ipv4.tcp_available_congestion_control.
```

[bandwith deplay](https://en.wikipedia.org/wiki/Bandwidth-delay_product)

##tools name
```
nc
glance
atop
dd (disk)
iperf
nuttcp (like iperf)
```

```


In Linux/Intel I would use following methodology for performance analysis:

Hardware:

    turbostat
    Look for C/P states for cores, frequencies, number of SMIs. [1]
    cpufreq-info
    Look for current driver, frequencies, and governor.
    atop
    Look for interrupt distribution across cores
    Look for context switches, interrupts.
    ethtool
    -S for stats, look for errors, drops, overruns, missed interrupts, etc
    -k for offloads, enable GRO/GSO, rss(/rps/rfs)/xps
    -g for ring sizes, increase
    -c for interrupt coalescing

Kernel:

    /proc/net/softirq[2] and /proc/interrupts[3]
    Again, distribution, missed, delayed interrupts, (optional) NUMA-affinity
    perf top
    Look where kernel/benchmark spends its time.
    iptables
    Look if there are rules (if any) that may affect performance.
    netstat -s, netstat -m, /proc/net/*
    Look for error counters and buffer counts
    sysctl / grub
    So much to tweak here. Try increasing hashtable sizes, playing with memory buffers, congestion control, and other knobs.

In your case your main problem is interrupt distribution across the cores, so fixing it will be your best corse of action.

PS. Do not forget that in those kinds of benchmarks kernel and driver/firmware versions play a significant role.

PPS. You probably want to install the newest ixgbe driver from Intel[4]. Do not forget to read README there and examine scripts directory. It has lots of performance-related tips.

[0] Intel also has nice docs about scaling network performance
https://www.kernel.org/doc/Documentation/networking/scaling.txt
[1] You can pin your processor to a specific C-state:
https://gist.github.com/SaveTheRbtz/f5e8d1ca7b55b6a7897b
[2] You can analyze that data with:
https://gist.github.com/SaveTheRbtz/172b2e2eb3cbd96b598d
[3] You can set affinity with:
https://gist.github.com/SaveTheRbtz/8875474
[4] https://sourceforge.net/projects/e1000/files/ixgbe%20stable/
```