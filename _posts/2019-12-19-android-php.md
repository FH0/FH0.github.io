---
layout: post
title: 静态交叉编译 Android 的 PHP
category: 编译
---

### 说明
- 命令中涉及的依赖文件路径需要改成你自己的

### 准备工作
- [搭建 Android 编译环境]({% post_url 2019-11-22-android-environment %})
- [交叉编译 Android 的 zlib]({% post_url 2019-12-19-android-zlib %})
- [交叉编译 Android 的 OpenSSL]({% post_url 2019-11-22-android-openssl %})
- [交叉编译 Android 的 libcurl]({% post_url 2019-12-16-android-libcurl %})

### 编译
```shell
#从官网下载合适的版本并解压
php_version=7.4.0
wget -O- "https://www.php.net/distributions/php-$php_version.tar.gz" | tar xz

#进入编译目录
cd php-$php_version

#修改源码
sed -i 's|defined(HAVE_RES_NSEARCH)|defined(HAVE_RES_NSEARCH___)|g' $(grep -rl 'defined(HAVE_RES_NSEARCH)' .)
sed -i 's|define ZEND_MM_ALIGNMENT .*|define ZEND_MM_ALIGNMENT 8|g' Zend/zend_alloc.h
sed -i 's|dn_skipname(cp, end)|-1|g' ext/standard/dns.c
sed -i 's|defined(__aarch64__)|defined(__aarch64____)|g' ext/standard/crc32.c
sed -i 's|if HAVE_UNISTD_H|if HAVE_UNISTD_H__|g' $(grep -rl 'if HAVE_UNISTD_H' .)

#编译（arm）
./configure --enable-shared=no --without-libxml \
			--without-pear --disable-dom --disable-xmlwriter \
			--disable-xml --disable-xmlreader --with-curl \
			--without-pdo-sqlite --disable-simplexml \
			--disable-cgi --disable-phpdbg \
			--without-sqlite3 --host=arm-linux-androideabi \
			--without-iconv \
			CURL_CFLAGS="-I/root/android-arm/include" \
			CURL_LIBS="-L/root/android-arm/lib -lcurl" \
			ZLIB_CFLAGS="-I/root/android-arm/include" \
			ZLIB_LIBS="-L/root/android-arm/lib -lz" \
			OPENSSL_CFLAGS="-I/root/android-arm/include" \
			OPENSSL_LIBS="-L/root/android-arm/lib -lssl -lcrypto"
make LDFLAGS="-all-static" -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
mv sapi/cli/php ../php_arm
make clean

#编译（arm64）
./configure --enable-shared=no --without-libxml \
			--without-pear --disable-dom --disable-xmlwriter \
			--disable-xml --disable-xmlreader --with-curl \
			--without-pdo-sqlite --disable-simplexml \
			--disable-cgi --disable-phpdbg \
			--without-sqlite3 --host=aarch64-linux-android \
			--without-iconv \
			CURL_CFLAGS="-I/root/android-arm64/include" \
			CURL_LIBS="-L/root/android-arm64/lib -lcurl" \
			ZLIB_CFLAGS="-I/root/android-arm64/include" \
			ZLIB_LIBS="-L/root/android-arm64/lib -lz" \
			OPENSSL_CFLAGS="-I/root/android-arm64/include" \
			OPENSSL_LIBS="-L/root/android-arm64/lib -lssl -lcrypto"
sed -i 's|-export-dynamic||g' Makefile
make LDFLAGS="-all-static -ldl" -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
mv sapi/cli/php ../php_arm64

#处理编译好的二进制文件
aarch64-linux-android-strip ../php_arm*
```

编译完之后，就可以删除源文件了
```shell
cd ..
rm -rf php-$php_version
```

### 下载
[编译好的文件](/assets/android-php.tgz)

