# All register sysctl using tunning k8s kernel `5.14.0-611.13.1.el9_7.x86_64`

## All register

```

net.core.somaxconn: "65535"
net.ipv4.tcp_max_syn_backlog: "65535"

net.core.netdev_max_backlog: "65535"

net.core.rmem_max: "16777216"
net.core.wmem_max: "16777216"
net.core.rmem_default: "1048576"
net.core.wmem_default: "1048576"
net.core.optmem_max: "65535"
net.ipv4.tcp_rmem: "4096 1048576 16777216"
net.ipv4.tcp_wmem: "4096 1048576 16777216"
net.ipv4.tcp_slow_start_after_idle: "0"
net.ipv4.tcp_fin_timeout: "15"
net.ipv4.tcp_keepalive_time: "300"
net.ipv4.tcp_keepalive_intvl: "30"
net.ipv4.tcp_keepalive_probes: "5"
net.ipv4.tcp_max_tw_buckets: "1440000"
net.ipv4.tcp_syncookies: "1"
net.ipv4.tcp_timestamps: "1"
net.ipv4.tcp_sack: "1"
net.ipv4.tcp_window_scaling: "1"
net.ipv4.ip_forward: "1"
net.bridge.bridge-nf-call-iptables: "1"
net.bridge.bridge-nf-call-ip6tables: "1"
net.ipv6.conf.all.forwarding: "1"
net.netfilter.nf_conntrack_max: "1048576"
fs.file-max: "2097152"
fs.nr_open: "2097152"
fs.inotify.max_user_watches: "524288"
fs.inotify.max_user_instances: "512"
vm.dirty_ratio: "40"
vm.dirty_background_ratio: "10"
vm.max_map_count: "262144"
vm.overcommit_memory: "1"
kernel.pid_max: "4194304"
kernel.threads-max: "4194304"
net.ipv4.ip_local_port_range: "1024 65535"
```

## Tools for benmark
```
perf
netstat
ss
ethtool
wrk
```

### Using sysctl for container (containerd or cri-o v2)


## Link perferences:
```
https://garycplin.blogspot.com/2017/06/linux-network-scaling-receives-packets.html
https://ntk148v.github.io/posts/linux-network-performance-ultimate-guide/
https://medium.com/@anooshcnayak/tcp-journey-of-achieving-1-million-connections-part-1-87c010a40d01
```

## linux network overview
![overview](img/linux_network_flow.png)

### Explain
#### 1. net.core.somaxconn & net.ipv4.tcp_max_syn_backlog
Determines the maximum number of connections that can be queued in the TCP/IP stack backlog per socket. <br>
With `tcp_max_syn_backlog` is maximal number of remembered connection requests, which have not
received an acknowledgment from connecting client.
The minimal value is 128 for low memory machines, and it will
increase in proportion to the memory of machine.

#### 1.1 Before
In rocky linux 9.7, net.core.somaxconn set default `4096` and net.ipv4.tcp_max_syn_backlog `512`

#### 1.2 After tunning
#### 1.3 Impact to server
```
# tcp_max_syn_backlog impact:
# - Each SYN: ~300 bytes
# - Max memory: 65535 × 300 bytes = ~20 MB

# somaxconn impact:
# - Each established connection: ~2-4 KB
# - Max memory: 65535 × 4 KB = ~256 MB
```

#### 2. net.core.netdev_max_backlog
`net.core.netdev_max_backlog` controls the maximum number of packets queued on the INPUT side of each NIC operates on layer 2/3  when the kernel receives packets faster than it can process them.
#### 2.1 Before
In rocky linux 9.7, net.core.netdev_max_backlog set default `1000`

### Setup lab for to prove sysctl working
