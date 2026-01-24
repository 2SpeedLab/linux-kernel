# Compute resource

|CPU|RAM|
|---|---|
|4|8|

# result test 10gb without idle=0
```
Test Complete. Summary Results:
[ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams
[  5] (sender statistics not available)
[  5]   0.00-10.03  sec  21.6 MBytes  18.0 Mbits/sec  0.870 ms  860/16470 (5.2%)  receiver
[  6] (sender statistics not available)
[  6]   0.00-10.03  sec  10.8 MBytes  9.03 Mbits/sec  1.520 ms  1294/9116 (14%)  receiver
[  9] (sender statistics not available)
[  9]   0.00-10.03  sec  21.6 MBytes  18.0 Mbits/sec  0.859 ms  866/16476 (5.3%)  receiver
[ 11] (sender statistics not available)
[ 11]   0.00-10.03  sec  21.6 MBytes  18.0 Mbits/sec  0.855 ms  914/16524 (5.5%)  receiver
[ 13] (sender statistics not available)
[ 13]   0.00-10.03  sec  21.6 MBytes  18.0 Mbits/sec  0.831 ms  936/16546 (5.7%)  receiver
[ 15] (sender statistics not available)
[ 15]   0.00-10.03  sec  21.6 MBytes  18.0 Mbits/sec  0.867 ms  845/16455 (5.1%)  receiver
[ 17] (sender statistics not available)
[ 17]   0.00-10.03  sec  21.6 MBytes  18.0 Mbits/sec  0.884 ms  838/16447 (5.1%)  receiver
[ 19] (sender statistics not available)
[ 19]   0.00-10.03  sec  21.6 MBytes  18.0 Mbits/sec  0.846 ms  854/16463 (5.2%)  receiver
[ 21] (sender statistics not available)
[ 21]   0.00-10.03  sec  21.6 MBytes  18.0 Mbits/sec  0.907 ms  906/16515 (5.5%)  receiver
[ 23] (sender statistics not available)
[ 23]   0.00-10.03  sec  10.8 MBytes  9.02 Mbits/sec  1.450 ms  1224/9033 (14%)  receiver
[ 25] (sender statistics not available)
[ 25]   0.00-10.03  sec  21.6 MBytes  18.0 Mbits/sec  0.896 ms  780/16389 (4.8%)  receiver
[ 27] (sender statistics not available)
[ 27]   0.00-10.03  sec  21.6 MBytes  18.0 Mbits/sec  0.853 ms  859/16468 (5.2%)  receiver
[SUM]   0.00-10.03  sec   237 MBytes   198 Mbits/sec  0.970 ms  11176/182902 (6.1%)  receiver
iperf 3.9
Linux rocky--1 5.14.0-611.13.1.el9_7.x86_64 #1 SMP PREEMPT_DYNAMIC Fri Dec 12 11:55:11 UTC 2025 x86_64
```

# Result test with idle=0
```
Test Complete. Summary Results:
[ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams
[  5] (sender statistics not available)
[  5]   0.00-10.02  sec  19.8 MBytes  16.6 Mbits/sec  1.019 ms  2028/16397 (12%)  receiver
[  6] (sender statistics not available)
[  6]   0.00-10.02  sec  19.8 MBytes  16.6 Mbits/sec  1.027 ms  1941/16310 (12%)  receiver
[  9] (sender statistics not available)
[  9]   0.00-10.02  sec  19.8 MBytes  16.6 Mbits/sec  1.037 ms  1762/16131 (11%)  receiver
[ 11] (sender statistics not available)
[ 11]   0.00-10.02  sec  19.8 MBytes  16.6 Mbits/sec  1.076 ms  1818/16187 (11%)  receiver
[ 13] (sender statistics not available)
[ 13]   0.00-10.02  sec  19.8 MBytes  16.6 Mbits/sec  1.035 ms  2015/16384 (12%)  receiver
[ 15] (sender statistics not available)
[ 15]   0.00-10.02  sec  19.8 MBytes  16.6 Mbits/sec  1.093 ms  1799/16167 (11%)  receiver
[ 17] (sender statistics not available)
[ 17]   0.00-10.02  sec  19.8 MBytes  16.6 Mbits/sec  1.083 ms  2008/16376 (12%)  receiver
[ 19] (sender statistics not available)
[ 19]   0.00-10.02  sec  19.8 MBytes  16.6 Mbits/sec  1.205 ms  0/14368 (0%)  receiver
[ 21] (sender statistics not available)
[ 21]   0.00-10.02  sec  19.8 MBytes  16.6 Mbits/sec  1.055 ms  2155/16523 (13%)  receiver
[ 23] (sender statistics not available)
[ 23]   0.00-10.02  sec  19.8 MBytes  16.6 Mbits/sec  1.093 ms  1677/16045 (10%)  receiver
[ 25] (sender statistics not available)
[ 25]   0.00-10.02  sec  19.8 MBytes  16.6 Mbits/sec  1.098 ms  1677/16045 (10%)  receiver
[ 27] (sender statistics not available)
[ 27]   0.00-10.02  sec  19.8 MBytes  16.6 Mbits/sec  1.052 ms  1957/16325 (12%)  receiver
[SUM]   0.00-10.02  sec   238 MBytes   199 Mbits/sec  1.073 ms  20837/193258 (11%)  receiver
iperf 3.9
Linux rocky--1 5.14.0-611.13.1.el9_7.x86_64 #1 SMP PREEMPT_DYNAMIC Fri Dec 12 11:55:11 UTC 2025 x86_64
```
![idle](img/idle.png)