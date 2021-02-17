---
layout: post
title: TProxy 与 Raw Socket
category: 折腾
---

&emsp;&emsp; 相比于新建 udp socket 然后 bind source，raw socket 可以反复利用，节省资源，提高性能。同时需要 root 权限也不是 raw socket 的缺点，因为 bind source 没有 root 权限的话无法绑定 1024 以下的端口。

&emsp;&emsp;看到这里基本上都是写代码的老兄了，我就献丑把用 Rust 写的代码粘贴出来了。recvmsg 的代码可以看 [shadowsocks-rust](https://github.com/shadowsocks/shadowsocks-rust/blob/3d8c4cb641e921873ebe2fdf4d04367a5c234e0a/crates/shadowsocks-service/src/local/redir/udprelay/sys/unix/linux.rs#L180)
```rust
fn udp_sendto(
    &self,
    saddr: String,
    daddr: String,
    buf: Vec<u8>,
) -> Result<(), Box<dyn std::error::Error + Send + Sync>> {
    let saddr = saddr.to_socket_addrs()?.next().unwrap();
    let daddr = daddr.to_socket_addrs()?.next().unwrap();

    match (saddr, daddr) {
        (SocketAddr::V4(saddr), SocketAddr::V4(daddr)) => self.clone().udp_sendto4(
            *saddr.ip(),
            saddr.port(),
            *daddr.ip(),
            daddr.port(),
            buf,
        )?,
        (SocketAddr::V6(saddr), SocketAddr::V6(daddr)) => self.clone().udp_sendto6(
            *saddr.ip(),
            saddr.port(),
            *daddr.ip(),
            daddr.port(),
            buf,
        )?,
        _ => unreachable!(),
    }

    Ok(())
}

fn udp_sendto4(
    &self,
    saddr: Ipv4Addr,
    sport: u16,
    daddr: Ipv4Addr,
    dport: u16,
    data_buf: Vec<u8>,
) -> Result<(), Box<dyn std::error::Error + Send + Sync>> {
    let mut udp_buf = vec![0u8; UDPLEN];

    let mut ip_header = ipv4::MutableIpv4Packet::new(&mut udp_buf).unwrap();
    ip_header.set_version(4);
    ip_header.set_header_length(5);
    ip_header.set_total_length(20 + 8 + data_buf.len() as u16);
    ip_header.set_ttl(64);
    ip_header.set_next_level_protocol(IpNextHeaderProtocols::Udp);
    ip_header.set_source(saddr);
    ip_header.set_destination(daddr);
    let checksum = ipv4::checksum(&ip_header.to_immutable());
    ip_header.set_checksum(checksum);

    let payload = ip_header.payload_mut();
    let mut udp_header = MutableUdpPacket::new(payload).unwrap();
    udp_header.set_source(sport);
    udp_header.set_destination(dport);
    udp_header.set_length((8 + data_buf.len()) as u16);
    udp_header.set_payload(&data_buf);
    let checksum = udp::ipv4_checksum(&udp_header.to_immutable(), &saddr, &daddr);
    udp_header.set_checksum(checksum);

    udp_buf.resize(20 + 8 + data_buf.len(), 0);

    let daddr_socketaddr = SocketAddrV4::new(daddr, dport);
    if unsafe {
        libc::sendto(
            self.raw4,
            udp_buf.as_mut_ptr() as *mut _,
            udp_buf.len(),
            0,
            &daddr_socketaddr as *const _ as *const libc::sockaddr,
            std::mem::size_of_val(&daddr_socketaddr) as _,
        ) == -1
    } {
        Err(io::Error::last_os_error())?;
    }

    Ok(())
}

fn udp_sendto6(
    &self,
    saddr: Ipv6Addr,
    sport: u16,
    daddr: Ipv6Addr,
    dport: u16,
    data_buf: Vec<u8>,
) -> Result<(), Box<dyn std::error::Error + Send + Sync>> {
    let mut udp_buf = vec![0u8; UDPLEN];

    let mut ip_header = ipv6::MutableIpv6Packet::new(&mut udp_buf).unwrap();
    ip_header.set_version(6);
    ip_header.set_payload_length(8 + data_buf.len() as u16);
    ip_header.set_hop_limit(64);
    ip_header.set_next_header(IpNextHeaderProtocols::Udp);
    ip_header.set_source(saddr);
    ip_header.set_destination(daddr);

    let payload = ip_header.payload_mut();
    let mut udp_header = MutableUdpPacket::new(payload).unwrap();
    udp_header.set_source(sport);
    udp_header.set_destination(dport);
    udp_header.set_length((8 + data_buf.len()) as u16);
    udp_header.set_payload(&data_buf);
    let checksum = udp::ipv6_checksum(&udp_header.to_immutable(), &saddr, &daddr);
    udp_header.set_checksum(checksum);

    udp_buf.resize(40 + 8 + data_buf.len(), 0);

    let daddr_socketaddr = SocketAddrV6::new(daddr, dport, 0, 0);
    if unsafe {
        libc::sendto(
            self.raw6,
            udp_buf.as_mut_ptr() as *mut _,
            udp_buf.len(),
            0,
            &daddr_socketaddr as *const _ as *const libc::sockaddr,
            std::mem::size_of_val(&daddr_socketaddr) as _,
        ) == -1
    } {
        Err(io::Error::last_os_error())?;
    }

    Ok(())
}
```