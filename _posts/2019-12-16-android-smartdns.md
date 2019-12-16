---
layout: post
title: 静态编译 Android 的 SmartDNS
category: 编译
---

### 准备工作
- [搭建 Android 编译环境][android-environment]
- [交叉编译 Android 的 OpenSSL][android-openssl]

### 编译
```shell
#从官网下载合适的版本并解压
smartdns_version=28
wget -O- "https://github.com/pymumu/smartdns/archive/Release$smartdns_version.tar.gz" | tar xz

#进入编译目录
cd smartdns-Release$smartdns_version

#修改编译参数
sed -i 's|-lpthread||g' src/Makefile

#编译（arm），下面的 LDFLAGS 和 CFLAGS 需要设置成 OpenSSL 的路径
LDFLAGS="-L/root/android-arm/lib" CFLAGS="-I/root/android-arm/include" bash package/build-pkg.sh --platform linux --arch arm-linux-androideabi --cross-tool arm-linux-androideabi- --static
mv src/smartdns ../smartdns_arm

#编译（arm64），下面的 LDFLAGS 和 CFLAGS 需要设置成 OpenSSL 的路径
LDFLAGS="-L/root/android-arm64/lib" CFLAGS="-I/root/android-arm64/include" bash package/build-pkg.sh --platform linux --arch aarch64-linux-android --cross-tool aarch64-linux-android- --static
mv src/smartdns ../smartdns_arm64

#处理编译好的二进制文件
cd ..
aarch64-linux-android-strip smartdns_arm*
```

编译完之后，就可以删除源文件了
```shell
rm -rf smartdns-Release$smartdns_version
```

### 下载
[编译好的文件](/assets/android-smartdns.tar.gz)

[android-environment]: /编译/2019/11/22/android-environment.html
[android-openssl]: /编译/2019/11/22/android-openssl.html