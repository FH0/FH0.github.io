---
layout: post
title: TProxy 与策略路由
category: 折腾
---

&emsp;&emsp;这里有两个相关的链接，<https://www.kernel.org/doc/Documentation/networking/tproxy.txt>，<https://osric.com/chris/accidental-developer/2019/03/linux-policy-based-routing/>

&emsp;&emsp;在例如 <https://blog.i7mc.com/2019/%E9%80%8F%E6%98%8E%E4%BB%A3%E7%90%86%E8%B8%A9%E5%9D%91%E6%8C%87%E5%8C%97/> 之类的绝大多数教程都在 mangle 的 PREROUTING 链上放行了内网。表面上内网不需要代理，放行了合情合理，而且实际用起来也没什么问题。可事实并非如此。

&emsp;&emsp;为什么 PREROUTING 会有发往内网的数据包？如果是路由器上，那么放行 192.168.0.0/16 的数据包不就行了？为什么还要放行 10.0.0.0/8 之类的内网。我猜写这些教程的人也不清楚，我一开始也不懂，也是用着网上的这些教程上面的代码，用着也没问题。直到有一天，网卡的 ip 地址由原来的内网变成了公网，而 TPROXY 的透明代理规则让设备没了网络。原因只有一个，内网变成了公网，这是我含泪测试出来的。

&emsp;&emsp;可我找遍了教程，也没有一个教程说内网与公网的问题。我，只能自己解决。在解决的过程中 <https://www.tcpdump.org/manpages/tcpdump.1.html> 和 iptables 的 LOG 给我提供了巨大的帮助。

```bash
ip route add local default dev lo table 2000
ip rule add from all fwmark 0x20000 lookup 2000

iptables -t mangle -A PREROUTING -s 192.168.0.0/16 ! -d 192.168.0.0/16 -p tcp -j TPROXY --on-port 2000 --tproxy-mark 0x20000
iptables -t mangle -A PREROUTING -s 192.168.0.0/16 ! -d 192.168.0.0/16 -p udp -j TPROXY --on-port 2000 --tproxy-mark 0x20000
```

&emsp;&emsp;我发现一个小技巧就是 `ip route add` 那里其实可以进行分流。

-
-
-
-
- 加更
-
-
-
-

&emsp;&emsp;再说说 OUTPUT 吧。比如，路由器只能代理它的子网，而它本身是不能代理的，因为没有添加 OUTPUT 上的规则。要弄清楚这个，得搞懂支持 TPROXY 的代理软件是怎么把数据发回去的。

```txt
对于 TCP，就是直接写就行了，但是返回去的数据包会被 TPROXY 打上标记，从而路由。这是不行的，所以要取消标记，从而不被路由。

对于 UDP，一般是新建一个 socket，然后 bind source。或者是用 raw socket，感兴趣可以看看[这篇文章]({% post_url 2021-02-17-tproxy-raw-socket %})。没什么问题。
```

&emsp;&emsp;下面的规则会同时代理本机和被转发的设备的数据。当然，需要 [setgid](https://man7.org/linux/man-pages/man2/setgid.2.html) 为 2000，这也是一个小技巧，通过 gid 来放行（uid 为 0，gid 为 2000 是被允许的）。至于 DNS 什么的。。。
```bash
ip route add local default dev lo table 2000
ip rule add from all fwmark 0x20000 lookup 2000

iptables -t mangle -A OUTPUT -m owner --gid-owner 2000 -j MARK --set-xmark 0 # 所说的清除 TCP 标记
iptables -t mangle -A OUTPUT -m owner --gid-owner 2000 -j ACCEPT
iptables -t mangle -A OUTPUT -d 0.0.0.0/8 -j ACCEPT
iptables -t mangle -A OUTPUT -d 100.64.0.0/10 -j ACCEPT
iptables -t mangle -A OUTPUT -d 127.0.0.0/8 -j ACCEPT
iptables -t mangle -A OUTPUT -d 169.254.0.0/16 -j ACCEPT
iptables -t mangle -A OUTPUT -d 192.0.0.0/24 -j ACCEPT
iptables -t mangle -A OUTPUT -d 192.0.2.0/24 -j ACCEPT
iptables -t mangle -A OUTPUT -d 192.88.99.0/24 -j ACCEPT
iptables -t mangle -A OUTPUT -d 198.18.0.0/15 -j ACCEPT
iptables -t mangle -A OUTPUT -d 198.51.100.0/24 -j ACCEPT
iptables -t mangle -A OUTPUT -d 203.0.113.0/24 -j ACCEPT
iptables -t mangle -A OUTPUT -d 172.16.0.0/12 -j ACCEPT
iptables -t mangle -A OUTPUT -d 192.168.0.0/16 -j ACCEPT
iptables -t mangle -A OUTPUT -d 10.0.0.0/8 -j ACCEPT
iptables -t mangle -A OUTPUT -d 224.0.0.0/3 -j ACCEPT
iptables -t mangle -A OUTPUT -p tcp -j MARK --set-xmark 0x20000
iptables -t mangle -A OUTPUT -p udp -j MARK --set-xmark 0x20000

iptables -t mangle -A PREROUTING -p tcp -s 192.168.0.0/16 ! -d 192.168.0.0/16 -j MARK --set-xmark 0x20000
iptables -t mangle -A PREROUTING -p udp -s 192.168.0.0/16 ! -d 192.168.0.0/16 -j MARK --set-xmark 0x20000
iptables -t mangle -A PREROUTING -p tcp -m mark --mark 0x20000 -j TPROXY --on-port 2000 --tproxy-mark 0x20000
iptables -t mangle -A PREROUTING -p udp -m mark --mark 0x20000 -j TPROXY --on-port 2000 --tproxy-mark 0x20000
```

&emsp;&emsp;上面的规则是一边写一边测试的。