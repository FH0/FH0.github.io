---
layout: post
title: Android 运行 OpenVPN Server 的大致流程
category: 折腾
---

### 说明
- 其中涉及很多知识，故只写主要步骤

### 开始
```shell
#创建 OpenVPN 运行时需要的文件夹
mkdir -p /data/tmp

#允许数据包的转发
echo 1 >/proc/sys/net/ipv4/ip_forward

#启动 OpenVPN
/system/etc/dropbear/openvpn --daemon ovpn-server --tmp-dir /data/tmp --dev-node /dev/tun --cd /system/etc/dropbear/openvpn-server/server --config udp_809.conf

#允许 OpenVPN 所在的网卡流量转发
iptables -I FORWARD -i tun0 -j ACCEPT
iptables -I FORWARD -o tun0 -j ACCEPT

#设置正确的源地址
iptables -t nat -I POSTROUTING -s 10.8.0.0/24 ! -d 10.8.0.0/24 -j MASQUERADE

#为 OpenVPN 的流量选择路由
ip route add table 1002 10.8.0.0/24 dev tun0 scope link
```
