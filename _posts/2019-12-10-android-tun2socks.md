---
layout: post
title: 编译 Android 的 tun2socks（支持 --enable-udprelay）
category: 编译
---

### 准备工作
- [搭建 Android 编译环境][android-environment]

### 编译
```shell
#克隆源码，需要安装 git
mkdir badvpn
cd badvpn
git clone "https://github.com/FH0/badvpn.git" jni

#编译
ndk-build

#处理编译好的文件
mv libs/armeabi-v7a/tun2socks ../tun2socks_arm
mv libs/arm64-v8a/tun2socks ../tun2socks_arm64
```

编译完之后，就可以删除源文件了
```shell
cd ..
rm -rf badvpn
```

### 下载
[编译好的文件](/assets/android-tun2socks.tar.gz)

[android-environment]: /编译/2019/11/22/android-environment.html