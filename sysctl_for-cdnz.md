# All register sysctl using tunning kernel `5.14.0-611.13.1.el9_7.x86_64`

## System Specifications

| Network card | CPU | RAM |
|--------------|-----|-----|
| 40Gbps | 4 vcores (2294.686Mhz) | 8GB |

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
net.ipv4.ip_local_port_range: "1024 65535"
net.ipv4.ip_forward: "1"

fs.file-max: "2097152"
fs.nr_open: "2097152"

vm.dirty_ratio: "20"
vm.dirty_background_ratio: "10"
vm.overcommit_memory: "1"

kernel.pid_max: "4194304"
kernel.threads-max: "4194304"
```

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

#### 3. net.core.rmem_max & net.core.wmem_max & net.core.optmem_max
![max](img/rmem_max_and_wmem_max.jpg)
`net.core.optmem_max`
maximum ancillary buffer size allowed per socket. Ancillary data is a sequence
of struct cmsghdr structures with appended data. <br>
`net.core.rmem_max` the maximum receive socket buffer size in bytes. <br>
`net.core.wmem_max` The maximum send socket buffer size in bytes. <br>
#### 3.1 Before
In rocky linux 9.7, it setting
```
net.core.optmem_max = 81920
net.core.rmem_max = 212992
net.core.wmem_max = 212992
net.core.rmem_default = 212992
net.core.wmem_default = 212992
```

#### 4. net.ipv4.tcp_rmem & net.ipv4.tcp_wmem
`net.ipv4.tcp_wmem` controls the send buffer sizes for TCP sockets. This tuple consists of three values, representing the `minimum`, `default`, and `maximum` values for the send buffer.
<br>

`net.ipv4.tcp_rmem` controls the receive buffer sizes. <br>

With 2 setting above will be impact memory:
```
# Worst case scenario (all connections maxed out):
Memory = (tcp_rmem_max + tcp_wmem_max) × active_connections

# Example with your 10 MB settings:
1000 connections × 20 MB = 20 GB (theoretical max)
100 connections × 20 MB = 2 GB
```

#### 5. net.ipv4.tcp_slow_start_after_idle & net.ipv4.tcp_fin_timeout
`net.ipv4.tcp_slow_start_after_idle` controls whether TCP resets to slow start after an idle period
```
Example:
Connection transfers 1 GB, then idle for 10 seconds, then resumes:

tcp_slow_start_after_idle = 1:
  Resume → Start slow → Ramp up → Full speed (takes time)

tcp_slow_start_after_idle = 0:
  Resume → Immediately full speed
```
`net.ipv4.tcp_fin_timeout` controls how long a socket stays in FIN_WAIT_2 state waiting for final close.
```
Normal close sequence:
1. App calls close() → sends FIN → enters FIN_WAIT_1
2. Receives ACK → enters FIN_WAIT_2
3. Receives FIN from other side → sends ACK → enters TIME_WAIT
4. Waits 2×MSL (60s default) → CLOSED

tcp_fin_timeout controls step 2-3 timeout
```

#### 6. keepalive setting
`net.ipv4.tcp_keepalive_time` the number of seconds a connection needs to be idle before
TCP begins sending out keep-alive probes.  Keep-alives are sent only when the `SO_KEEPALIVE` socket option is enabled. <br>
`net.ipv4.tcp_keepalive_intvl` the number of seconds between TCP keep-alive probes. <br>
`net.ipv4.tcp_keepalive_probes` the maximum number of TCP keep-alive probes to send before
giving up and killing the connection if no response is obtained from the other end.

```
Dead connection detected in: 5 min + (30s × 5) = 7.5 minutes
```

#### 7. TCP performance and scalability tuning strategy
`net.ipv4.tcp_max_tw_buckets` maximum number of sockets in TIME_WAIT state.
`net.ipv4.tcp_syncookies: 1` Protection against SYN flood attacks.
```
Normal SYN handling:
Client → SYN → Server stores in SYN queue
Server → SYN-ACK → waits for ACK
Memory consumed per half-open connection

SYN flood attack:
Attacker sends thousands of SYNs without ACKing
→ SYN queue fills up
→ Legitimate clients can't connect
```
`net.ipv4.tcp_timestamps` adds timestamp option to TCP packets. <br>
`net.ipv4.tcp_sack` allows receiver to tell sender exactly which packets were received
```
With SACK:
Packets: [1] [2] [3] [4] [5]
Packet 3 lost
Client ACKs: "Got 1,2,4,5 - missing 3"
Server only resends: [3]
```
`net.ipv4.tcp_window_scaling` allows TCP window size > 64 KB. <br>
`net.ipv4.ip_forward` Enables IP packet forwarding (routing between interfaces).

#### 8. Netfilter & Connection tracking
`fs.file-max` System-wide maximum number of file handles (file descriptors) the kernel will allocate. <br>
`fs.nr_open` Per-process maximum number of file descriptors a single process can open.
```
Limit hierarchy:
fs.file-max          ← System-wide hard limit (2M)
    └─> fs.nr_open   ← Per-process ceiling (2M)
          └─> ulimit -n  ← Per-process soft/hard limit (must be ≤ nr_open)
```

#### 9. Virtual memory (VM) tuning
`vm.dirty_background_ratio` memory pages that still need to be written to disk — before the pdflush/flush/kdmflush background processes kick in to write it to disk. My example is 10%, so if my virtual server has 32 GB of memory that’s 3.2 GB of data that can be sitting in RAM before something is done. <br>

`vm.dirty_ratio` is the absolute maximum amount of system memory that can be filled with dirty pages before everything must get committed to disk. When the system gets to this point all new I/O blocks until dirty pages have been written to disk. This is often the source of long I/O pauses, but is a safeguard against too much data being cached unsafely in memory.

```
┌─────────────────────────────────────────────┐
│ DIRTY PAGE MANAGEMENT                       │
├─────────────────────────────────────────────┤
│                                             │
│ 0% ───────────────────────────────────────  │ No action
│                                             │
│ 10% ← dirty_background_ratio                │ Background flush starts
│      ├─ Gentle disk writes                  │ (non-blocking)
│      ├─ Processes continue normally         │
│      └─ Goal: prevent reaching dirty_ratio  │
│                                             │
│ 20% ← dirty_ratio                           │ HARD LIMIT
│      ├─ Processes BLOCKED on writes         │ (blocking)
│      ├─ Aggressive flushing                 │
│      └─ Performance impact                  │
└─────────────────────────────────────────────┘
```
`vm.overcommit_memory: 1` the kernel performs no memory overcommit handling. This increases the possibility of memory overload, but improves performance for memory-intensive tasks.

#### 10. Process & thread limits
`kernel.pid_max` the maximum numerical PROCESS IDENTIFIER than can be assigned by the kernel. <br>
`kernel.threads-max` system-wide maximum number of threads (tasks).
```
Formula: max_threads = total_RAM_KB / 8
Example: 8 GB RAM = (8 × 1024 × 1024) / 8 = 1,048,576 (1M threads)
```

## Note:
### 1.1 Jumbo frames
By default the maximum transmission unit (MTU) is 1500 bytes. Jumbo frames should be enabled when the MTU is larger than the default, or when smaller messages are aggregated to be larger than 1500 bytes. By enabling jumbo frames, more data is sent per ethernet frame. The MTU may be increased to a value up to 9000 bytes. <br>

To enable jumbo frames add the following line to the configuration script of the network interface, such as /etc/sysconfig/network-scripts/ifcfg-eth0: <br>
```
MTU=9000
```

## link references
[Using perl tool](https://www.brendangregg.com/perf.html) <br>
[Measuring Workload Performance with Hardware Performance](https://docs.nvidia.com/dccpu/grace-perf-tuning-guide/measuring-performance.html) <br>
[Oracle Tunning](https://docs.oracle.com/cd/E18930_01/html/821-2431/abeji.html)
[Tuinning with LAN 10GbE](https://glenewhittenberg.blogspot.com/2016/03/intel-x520-da2-performance-tuning-for.html) <br>
[Network tuning - a practical guide](https://indico.cern.ch/event/274974/contributions/620868/attachments/497313/687046/RV_Network_ALICE_WKS_20140307_v0.pdf) <br>
[rmem.c](https://elixir.bootlin.com/linux/v5.15.78/source/drivers/nvmem/rmem.c) <br>
[Bandwidth-delay product](https://en.wikipedia.org/wiki/Bandwidth-delay_product) <br>
[Test/Measurement Host Tuning](https://fasterdata.es.net/host-tuning/linux/test-measurement-host-tuning/) <br>
[net/sysctl](https://docs.kernel.org/admin-guide/sysctl/net.html) <br>
[kernel/sysctl](https://origin.kernel.org/doc/html/latest/admin-guide/sysctl/kernel.html) <br>
