---
layout: post
title: 基于 V2Ray 的透明代理
category: 折腾
---

### 目标
- 代理所有由主机发出的 TCP，UDP 和 DNS 数据包

### 兼容性
- 理论上所有的 64 位 Linux 系统（已在 CentOS-6-x64 和 Debian-9-x64 上测试通过）

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

#如图编辑 V2Ray 配置文件，也就是 config.json
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
