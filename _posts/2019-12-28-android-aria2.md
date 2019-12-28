---
layout: post
title: 交叉编译 Android 的 aria2
category: 编译
---

### 准备工作
- [搭建 Android 编译环境](/编译/2019/11/22/android-environment.html)
- [交叉编译 Android 的 OpenSSL](/编译/2019/11/22/android-openssl.html)
- [交叉编译 Android 的 zlib](/编译/2019/12/19/android-zlib.html)
- [交叉编译 Android 的 c-ares](/编译/2019/12/28/android-c-ares.html)
- [交叉编译 Android 的 libssh2](/编译/2019/12/28/android-libssh2.html)
- [交叉编译 Android 的 expat](/编译/2019/12/28/android-expat.html)

### 编译
```shell
wget -O- "https://github.com/aria2/aria2/releases/download/release-1.35.0/aria2-1.35.0.tar.gz" | tar xz
cd aria2-1.35.0
sed -i 's|-lrt||g;s|-lpthread||g' $(grep -rEl '\-lrt|\-lpthread' .)
sed -i 's|timegm(|timegm_(|g' $(grep -rl 'timegm(' .)
#for arm
./configure --host=arm-linux-androideabi --without-gnutls --with-openssl --without-libxml2 ARIA2_STATIC=yes \
			ZLIB_CFLAGS="-I/root/android-arm/include" \
			ZLIB_LIBS="-L/root/android-arm/lib -lz" \
			EXPAT_CFLAGS="-I/root/android-arm/include" \
			EXPAT_LIBS="-L/root/android-arm/lib -lexpat" \
			SQLITE3_CFLAGS="-I/root/android-arm/include" \
			SQLITE3_LIBS="-L/root/android-arm/lib -lsqlite3" \
			OPENSSL_CFLAGS="-I/root/android-arm/include" \
			OPENSSL_LIBS="-L/root/android-arm/lib -lssl -lcrypto" \
			LIBCARES_CFLAGS="-I/root/android-arm/include" \
			LIBCARES_LIBS="-L/root/android-arm/lib -lcares" \
			LIBSSH2_CFLAGS="-I/root/android-arm/include" \
			LIBSSH2_LIBS="-L/root/android-arm/lib -lssh2"
make -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
mv src/aria2c ../aria2c_arm
make clean
#for arm64
./configure --host=aarch64-linux-android --without-gnutls --with-openssl --without-libxml2 ARIA2_STATIC=yes \
			ZLIB_CFLAGS="-I/root/android-arm64/include" \
			ZLIB_LIBS="-L/root/android-arm64/lib -lz" \
			EXPAT_CFLAGS="-I/root/android-arm64/include" \
			EXPAT_LIBS="-L/root/android-arm64/lib -lexpat" \
			SQLITE3_CFLAGS="-I/root/android-arm64/include" \
			SQLITE3_LIBS="-L/root/android-arm64/lib -lsqlite3" \
			OPENSSL_CFLAGS="-I/root/android-arm64/include" \
			OPENSSL_LIBS="-L/root/android-arm64/lib -lssl -lcrypto" \
			LIBCARES_CFLAGS="-I/root/android-arm64/include" \
			LIBCARES_LIBS="-L/root/android-arm64/lib -lcares" \
			LIBSSH2_CFLAGS="-I/root/android-arm64/include" \
			LIBSSH2_LIBS="-L/root/android-arm64/lib -lssh2"
make LIBS='-ldl' -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
mv src/aria2c ../aria2c_arm64
aarch64-linux-android-strip ../aria2c_arm*
cd ..
rm -rf aria2-1.35.0
```

### 下载
[编译好的文件](/assets/android-aria2.tgz)
