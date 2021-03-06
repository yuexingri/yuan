#!/usr/bin/env bash
#firewall的常用用法
#firewalld 配置文件 /etc/firewalld/zones/public.xml  默认的zone  其他的配置文件 rpm -qc firewalld
firewall --list-all #查看规则
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 1 -s 192.168.1.0/24 -p tcp --dport=22 -j ACCEPT #允许192.168.1.0 的网段的SSH连接
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 2 -p tcp --dport=22 -j DROP  #拒绝所有的SSH连接
firewall-cmd --direct --get-all-rules      #获取firewalld设置的rules
firewall-cmd --add-port=80/tcp --permanent  #开放端口
firewall-cmd --add-service=http --permanent #开放某个服务 （同开放端口！只是把端口添加的一个配置文件里面）
firewall-cmd --zone=public --add-interface=eth0   #添加区域到某个网络接口
firewall-cmd [--zone=zone] --add-masquerade    #开启伪装
firewall-cmd --add-forward-port=222:proto=tcp:toport=333:toaddr=192.168.1.100  #ip转发将本地222端口转发到192.168.1.100的333端口
#iptables 常见用法
四表五链：fifter表、NAT表、Mangle表、Raw表  。  INPUT链、OUTPUT链、FORWARD链、PREROUTING链、POSTROUTING链
#rpm 常见用法 qa qc ql 命令脑补英文(很简单) /etc/sysconfig/iptables
保存配置  service iptables save 或者 /etc/rc.d/init.d/iptables save
查看规则  iptables -nvL  iptables -t(--tables) nat -nvL
清除所有规则；iptables -F -X -Z
iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT  #允许22号端口
iptables -I INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT #允许ping
iptables -I INPUT -j REJECT #禁止其他所有未允许的连接
iptables -I INPUT -s 123.45.6.0/24 -j DROP #封IP段即从123.45.6.1到123.45.6.254
nat上网：
		iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -o eth0 -j MASQUERADE #nat上网 -s 表示源网络即内网地址；-o 为连接因特网的接口
		#来自内网、出口为eth0的包接受转发；来自eth0、目标地址为内网，且连接状态为建立、相关的包接受转发 下面为开启防火墙的参数
		iptables -A FORWARD -s 192.168.122.0/24 -o eth0 -j ACCEPT
		iptables -A FORWARD -d 192.168.122.0/24 -m state --state ESTABLISHED,RELATED -i eth0 -j ACCEPT

iptables 设置转发();
iptables -t nat -A PREROUTING -p tcp -m tcp --dport 443 -j DNAT --to-destination 122.152.192.99:443 && \
iptables -t nat -A POSTROUTING -p tcp -m tcp --dport 443 -j SNAT --to-source 192.168.114.3 && \
service iptables save && service iptables restart

iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080

ocserv vpn设置iptables转发：
sudo iptables -t nat -A POSTROUTING -s 192.168.125.0/24 -o eth0 -j MASQUERADE #192.168.125.0/24 为vpn设置的网段
#指定源地址为192.168.125.0/24 的ip地址从eth0出去  -s(soure 源地址) -d(desion 目标地址)
sudo iptables -A FORWARD -i vpns+ -j ACCEPT #eth0 为主机外网网卡  vpns+ 为vpn创建得虚拟网卡
sudo iptables -A FORWARD -o vpns+ -j ACCEPT
