---
layout: post
title: Linux 搭建 smartdns
category: 折腾
---

```shell
key="smartdns"
wp="/usr/local/$key"
zip="$key.zip"
curl -sOL https://raw.githubusercontent.com/FH0/nubia/master/server_script/$zip
[ -d "$wp" ] && bash $wp/uninstall.sh >/dev/null 2>&1
rm -rf $wp ; mkdir -p $wp
unzip -q -o $zip -d $wp ; rm -f $zip
bash $wp/install.sh
```

![img](/assets/smartdns.png)
