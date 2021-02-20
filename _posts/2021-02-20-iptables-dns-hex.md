---
layout: post
title: iptables 匹配 dns 请求中的域名
category: 折腾
---

```bash
to_dns_hex() {
    echo "$1" | awk '{
        str_len = split($0, str, ".");
        for (elem in str) {
            printf "%02x", length(str[elem])
            system(sprintf("echo -n \"%s\" | od -A n -t x1 | tr \"\n\" \" \"", str[elem]))
        }

        printf "00"
    }'
}

iptables -t mangle -A SO -p udp --dport 53 -m string --algo kmp --from 28 --to 100 --hex-string "|$(to_dns_hex abc.com)|" -j ACCEPT
```

其中`$(to_dns_hex abc.com)`的结果为`03 61 62 63 03 63 6f 6d 00`，当然还有可以改进的地方，比如`awk`中还用到了 system 函数，依赖了 od 和 tr 命令。如果你改进了可以发送方案到我的邮箱，方便优化上面的示例。
