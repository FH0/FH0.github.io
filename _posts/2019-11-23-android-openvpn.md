---
layout: post
title: 静态交叉编译 Android 的 OpenVPN
category: 编译
---

### 准备工作
- [搭建 Android 编译环境]({% post_url 2019-11-22-android-environment %})

- [交叉编译 Android 的 OpenSSL]({% post_url 2019-11-22-android-openssl %})

- [交叉编译 Android 的 LZ4]({% post_url 2019-11-23-android-lz4 %})

- [交叉编译 Android 的 LZO]({% post_url 2019-11-23-android-lzo %})


### 编译
```shell
#首先从官网下载合适的版本
openvpn_version=2.4.8
wget "https://swupdate.openvpn.org/community/releases/openvpn-$openvpn_version.tar.gz"

#解压缩到当前目录
tar xf "openvpn-$openvpn_version.tar.gz"

#进入编译目录
cd openvpn-$openvpn_version

#设置依赖库路径
LIB_32_OPENSSL=~/android-arm
LIB_32_LZO=~/android-arm
LIB_32_LZ4=~/android-arm
LIB_64_OPENSSL=~/android-arm64
LIB_64_LZO=~/android-arm64
LIB_64_LZ4=~/android-arm64

#静态编译 32 位执行文件
./configure --host=arm-linux-androideabi --enable-static --disable-shared --disable-plugins --disable-debug \
	IFCONFIG="/system/bin/ifconfig" \
	OPENSSL_LIBS="-L$LIB_32_OPENSSL/lib -lssl -lcrypto" \
	OPENSSL_CFLAGS="-I$LIB_32_OPENSSL/include" \
	LZO_LIBS="-L$LIB_32_LZO/lib -llzo2" \
	LZ4_LIBS="-L$LIB_32_LZ4/lib -llz4"
make LIBS='-all-static' -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
mv src/openvpn/openvpn ../openvpn_arm
make clean

#静态编译 64 位执行文件
./configure --host=aarch64-linux-android --enable-static --disable-shared --disable-plugins --disable-debug \
	IFCONFIG="/system/bin/ifconfig" \
	OPENSSL_LIBS="-L$LIB_64_OPENSSL/lib -lssl -lcrypto" \
	OPENSSL_CFLAGS="-I$LIB_64_OPENSSL/include" \
	LZO_LIBS="-L$LIB_64_LZO/lib -llzo2" \
	LZ4_LIBS="-L$LIB_64_LZ4/lib -llz4"
make LIBS='-all-static -ldl' -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
mv src/openvpn/openvpn ../openvpn_arm64
```

返回上级目录，去掉执行文件的符号信息和调试信息，减小体积
```shell
cd ..
aarch64-linux-android-strip openvpn_arm*
```

然后就可以删除源文件了
```shell
rm -rf "openvpn-$openvpn_version" "openvpn-$openvpn_version.tar.gz"
```

### 下载
[编译好的文件](/assets/android-openvpn.tgz)

