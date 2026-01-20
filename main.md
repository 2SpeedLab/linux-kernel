## Setup lab
```
rocky-01: this server transmitted
rocky-02: this server recvied
rocky-03: this server collect metrics and display thourgh grafana
```

optional to this test
```
net.core.rmem_max: "16777216"
net.core.wmem_max: "16777216"
net.core.rmem_default: "1048576"
net.core.wmem_default: "1048576"
net.core.optmem_max: "65535"
```
#### Design test metrics

http://172.16.1.14:9090/targets
