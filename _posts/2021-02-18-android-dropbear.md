---
layout: post
title: 编译 Android 的 Dropbear
category: 编译
---

- 此文章对小白不友好，请了解每一条命令的作用后再执行
- 因为是静态可执行文件，所以 arm-linux-gnueabi 工具链即可，不需要专门的 ndk 工具链

```shell
curl -L "https://github.com/mkj/dropbear/archive/DROPBEAR_2018.76.tar.gz" | tar xz
cd dropbear-DROPBEAR_2018.76/
curl -OL "https://raw.githubusercontent.com/ubiquiti/dropbear-android/master/android-compat.patch"
curl -OL "https://raw.githubusercontent.com/ubiquiti/dropbear-android/master/config.guess"
curl -OL "https://raw.githubusercontent.com/ubiquiti/dropbear-android/master/config.sub"
autoreconf
patch -p1 < android-compat.patch
./configure --host=arm-linux-gnueabi --disable-utmp --disable-wtmp --disable-utmpx --disable-zlib --disable-syslog
make LDFLAGS=-static -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
cp dropbear dropbearkey dropbearconvert dbclient ..
arm-linux-gnueabi-strip dropbear dropbearkey dropbearconvert dbclient
rm -rf $(pwd)
cd ..
```

- 你可参考下面的启动命令

```shell
./dropbear -r ./dropbear_rsa_host_key -F -G root -U root -p 0.0.0.0:1122 -a -A -T ./public_key -s
```
