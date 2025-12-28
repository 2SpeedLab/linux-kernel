# All register sysctl using tunning k8s kernel `5.14.0-611.13.1.el9_7.x86_64`

## All register

```

net.core.somaxconn: "65535"
net.core.netdev_max_backlog: "65535"
net.core.rmem_max: "16777216"
net.core.wmem_max: "16777216"
net.core.rmem_default: "1048576"
net.core.wmem_default: "1048576"
net.core.optmem_max: "65535"
net.ipv4.tcp_rmem: "4096 1048576 16777216"
net.ipv4.tcp_wmem: "4096 1048576 16777216"
net.ipv4.tcp_max_syn_backlog: "65535"
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
```

### Using sysctl for container (containerd or cri-o v2)


## Link perferences:
```
https://garycplin.blogspot.com/2017/06/linux-network-scaling-receives-packets.html
https://ntk148v.github.io/posts/linux-network-performance-ultimate-guide/
```
