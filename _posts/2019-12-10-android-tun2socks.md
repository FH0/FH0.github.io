---
layout: post
title: 静态编译 Android 的 tun2socks（支持 --enable-udprelay）
category: 编译
---

### 准备工作
- [搭建 Android 编译环境][android-environment]

### 编译
```shell
#克隆源码，需要安装 git
git clone "https://github.com/FH0/badvpn.git"

#进入编译目录
cd badvpn

#编译（arm）
SRCDIR=. CC=arm-linux-androideabi-gcc ENDIAN=little \
	CFLAGS='-D BADVPN_SOCKS_UDP_RELAY' \
	LDFLAGS='-static' \
	bash compile-tun2sock.sh
mv ../tun2socks ../tun2socks_arm

#编译（arm64）
SRCDIR=. CC=aarch64-linux-android-gcc ENDIAN=little \
	CFLAGS='-D BADVPN_SOCKS_UDP_RELAY' \
	LDFLAGS='-static' \
	bash compile-tun2sock.sh
mv ../tun2socks ../tun2socks_arm64

#处理编译好的文件
cd ..
aarch64-linux-android-strip tun2socks_arm*
```

编译完之后，就可以删除源文件了
```shell
rm -rf badvpn
```

### 下载
[编译好的文件](/assets/android-tun2socks.tar.gz)

[android-environment]: /编译/2019/11/22/android-environment.html