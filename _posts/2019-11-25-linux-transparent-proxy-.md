---
layout: post
title: 基于v2ray的透明代理
category: 折腾
---

### 目标
- 代理所有由主机发出的TCP，UDP和DNS数据包

### 兼容性
- CentOS 7及以上版本
- Debian 9及以上版本
- Ubuntu 16.04及以上版本

### 安装工具包
```shell
#下载工具包
wget "https://fh0.github.io/assets/transparent-proxy/transparent-tools.zip"

#将工具包解压缩到合适的目录
Transparent_dir=/usr/local/transparent-proxy
mkdir -p $Transparent_dir
unzip transparent-tools.zip -d $Transparent_dir

#添加执行权限
chmod -R +x $Transparent_dir

#如图编辑v2ray配置文件，local_tcp.json和local_udp.json都使用下面的修改方法
#在local_udp中DNS的值需要多修改一遍，在下面的routing中也有关于DNS的值
```
![DNS](/assets/transparent-proxy/dns.jpg)

![Outbound](/assets/transparent-proxy/outbound.jpg)


```shell
#删除工具包
rm -f "transparent-tools.zip"
```
### 开启代理
```shell
#脚本会自动添加开机自启
$Transparent_dir/run.sh start
```

### 关闭代理
```shell
#脚本会自动关闭开机自启
$Transparent_dir/run.sh stop
```

### 卸载
```shell
$Transparent_dir/uninstall.sh
```

[systemd-rc-local]: /折腾/2019/11/26/systemd-rc-local.html
