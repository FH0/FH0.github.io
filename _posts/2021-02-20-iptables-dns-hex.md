---
layout: post
title: iptables 匹配 dns 请求中的域名
category: 折腾
---

```bash
to_dns_hex() {
    echo "$1" | awk 'BEGIN {
        for(n = 0; n < 256; n++) {
            ord[sprintf("%c",n)] = sprintf("%02x",n);
        }
    }
    {
        str_len = split($0, str, ".");
        for (elem in str) {
            printf "%02x ", length(str[elem])
            for (i = 0; i < length(str[elem]); i++) {
                printf "%s ", ord[substr(str[elem], i, 1)]
            }
        }

        printf "00"
    }'
}

iptables -t mangle -A SO -p udp --dport 53 -m string --algo kmp --from 28 --to 100 --hex-string "|$(to_dns_hex abc.com)|" -j ACCEPT
```
