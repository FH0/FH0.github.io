---
layout: post
title: Linux 搭建 tun2socks-v2ray 透明代理
category: 折腾
---

```shell
key="tun2socks"
wp="/usr/local/$key"
zip="$key.zip"
curl -sOL https://raw.githubusercontent.com/FH0/nubia/master/server_script/$zip
[ -d "$wp" ] && bash $wp/uninstall.sh >/dev/null 2>&1
rm -rf $wp ; mkdir -p $wp
unzip -q -o $zip -d $wp ; rm -f $zip
bash $wp/install.sh
```

![img](/assets/tun2socks.png)
