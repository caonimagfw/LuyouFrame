# OpenWrt 18.06.8

## 1. Apply one VPS (Ubuntu(LTS of 18,16,14)  1G Ram)
## 2. [Root]Set Swap Memory to 2G, and make it working after reboot
## 3. [openwrt] Install Caddy and wait 
## 4. [Root]Install all packaage use Root account
## 5. [Root]Install Go compiler package use Root account
## 6. [Root]Set Password Policy
## 7. [Root]Create User openwrt
## 8. [Root]Create folder and set chmod 777
## 9. [openwrt] git 18.06.8 code from openwrt 
## 10. [openwrt] git package 
## 11. [openwrt] Get Patch for Newifi-D1
## 12. [openwrt] get config firle 
## 13. [openwrt] compile and wait 
## 14. [openwrt] zip fiile and move to download 


## 1. Create user openwrt
```
	useradd openwrt
	passwd openwrt
	mkdir /home/openwrt
	usermod -s /bin/bash openwrt
	chown openwrt -R /home/openwrt
```
## 2. [openwrt] Install Caddy and wait 
```
wget --no-check-certificate -O caddy_install.sh https://raw.githubusercontent.com/caonimagfw/Caddy/master/caddy_install.sh && bash caddy_install.sh
```

## 3.Install openwrt and lede package 
```
sudo apt-get update
sudo apt-get install gcc g++ build-essential asciidoc  binutils bzip2 gawk gettext git libncurses5-dev libz-dev patch flex bison make autoconf texinfo unzip sharutils subversion ncurses-term zlib1g-dev ccache upx lib32gcc1 libc6-dev-i386 uglifyjs git-core gcc-multilib p7zip p7zip-full msmtp libssl-dev libglib2.0-dev xmlto qemu-utils automake libtool  -y
sudo apt-get -y install build-essential asciidoc binutils bzip2 gawk gettext git libncurses5-dev libz-dev patch python3.5 python2.7 unzip zlib1g-dev lib32gcc1 libc6-dev-i386 subversion flex uglifyjs git-core gcc-multilib p7zip p7zip-full msmtp libssl-dev texinfo libglib2.0-dev xmlto qemu-utils upx libelf-dev autoconf automake libtool autopoint device-tree-compiler g++-multilib antlr3 gperf
```
## 4.Create working Folder 
```
mkdir /home/openwrt/18.06.8
sudo chmod 777 /home/openwrt/18.06.8 
```

## 4.ipt2socks root 
```
# 进入某个目录
cd /opt
# 1.3.5 install then feed update and install
# 获取 libuv 源码包 1.35.0
libuv_version="1.32.0" # 定义 libuv 版本号
wget https://github.com/libuv/libuv/archive/v$libuv_version.tar.gz -Olibuv-$libuv_version.tar.gz
tar xvf libuv-$libuv_version.tar.gz

# 进入源码目录，编译
cd libuv-$libuv_version
./autogen.sh
./configure --prefix=/opt/libuv --enable-shared=no --enable-static=yes CC="gcc -O3"
make && sudo make install
cd ..

# 获取 ipt2socks 源码
git clone https://github.com/zfl9/ipt2socks

# 进入源码目录，编译
cd ipt2socks
make INCLUDES="-I/opt/libuv/include" LDFLAGS="-L/opt/libuv/lib" && sudo make install
```


## 5. get openwrt 18.06.8
```
su - openwrt
cd /home/openwrt/18.06.8
wget https://github.com/openwrt/openwrt/archive/v18.06.8.zip
unzip v18.06.8.zip
mv openwrt-18.06.8 openwrt
cd openwrt
cd package
git clone https://github.com/caonimagfw/openwrt-packages.git

#repare package
cd /home/openwrt/18.06.8/openwrt/feeds/packages/libs/libuv/
rm -rf Makefile
wget https://github.com/caonimagfw/LuyouFrame/raw/master/18.06.8/patch_package/feeds_pk_libs_libuv/Makefile
cd /home/openwrt/18.06.8/openwrt/

cd /home/openwrt/18.06.8/openwrt/package/libs && rm -rf openssl/
wget https://github.com/caonimagfw/LuyouFrame/raw/master/18.06.8/patch_package/openssl.zip && unzip openssl
cd /home/openwrt/18.06.8/openwrt/

cd /home/openwrt/18.06.8/openwrt/feeds/packages/net && rm -rf openssh/
wget https://github.com/caonimagfw/LuyouFrame/raw/master/18.06.8/patch_package/openssh.zip && unzip openssh
cd /home/openwrt/18.06.8/openwrt/

#wget
cd /home/openwrt/18.06.8/openwrt/package/feeds/packages && rm -rf wget/
wget https://github.com/caonimagfw/LuyouFrame/raw/master/18.06.8/patch_package/lede-wget.zip && unzip lede-wget.zip
cd /home/openwrt/18.06.8/openwrt/

https://github.com/caonimagfw/LuyouFrame/blob/master/18.06.8/patch_package/lede-wget.zip

#crytodev
cd /home/openwrt/18.06.8/openwrt/package/kernel
wget https://github.com/caonimagfw/LuyouFrame/raw/master/18.06.8/patch_package/lede-cryptodev.zip && unzip lede-cryptodev.zip
cd /home/openwrt/18.06.8/openwrt/

#openssl 
cd /home/openwrt/18.06.8/openwrt/build_dir/target-x86_64_musl/openssl-1.1.1g/crypto/
wget https://github.com/caonimagfw/LuyouFrame/raw/master/18.06.8/patch_package/cryptodev.h
cd /home/openwrt/18.06.8/openwrt/

./scripts/feeds update -a && ./scripts/feeds install -a

make menuconfig
make download -j2 V=s
make -j2 V=s

```



# install docker and tools 

```
yum -y install wget
wget --no-check-certificate -O onefast.sh https://raw.githubusercontent.com/caonimagfw/onefast/master/onefast.sh && bash onefast.sh


yum -y install net-tools && yum install -y bridge-utils

mkdir docker
cd docker
wget http://216.127.173.242:8099/openwrt-x86-64-generic-rootfs.tar.gz

curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

systemctl start docker
```

# docker openwrt 
```
docker import openwrt-x86-64-generic-rootfs.tar.gz lean_openwrt
--ip="192.168.10.10"
docker stop openwrt && docker rm openwrt 
--privileged 
docker run -it -d  -p 422:80 -p 443:443 --restart always --name openwrt lean_openwrt:v2 /sbin/init
docker ps

docker exec -it openwrt /bin/sh
/etc/init.d/firewall disable
/etc/init.d/firewall stop

chmod 777 /etc/init.d/ssrs && /etc/init.d/ssrs start

docker container port openwrt 


ifconfig docker0 down
docker run -it -d --restart always --privileged --name openwrt /sbin/init
docker run --ip=172.17.0.10  -dt --name test centos:7
```
#docker in Centos 

```
yum -y install net-tools

mkdir docker
cd docker
sudo yum install -y bridge-utils
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh


yum remove docker docker-common docker-selinux docker-engine 
rm -rf /var/lib/docker && rm -rf /etc/docker
wget http://216.127.173.242:8099/openwrt-x86-64-generic-rootfs.tar.gz

systemctl start docker
systemctl enable docker
systemctl disable docker
docker stop openwrt && docker rm openwrt
brctl show


/etc/init.d/firewall disable
/etc/init.d/firewall stop

　

#ip link set eth0 promisc on
ip link set docker0 promisc on

# 为 docker 创建 macvlan 虚拟接口，并链接到 host 网卡
# LAN 口
#docker network create -d macvlan --subnet=172.16.60.0/24 --gateway=172.16.60.254 --ipv6 --subnet=fe80::/16 --gateway=fe80::1 -o parent=ens33 -o macvlan_mode=bridge openwrt-LAN
#docker network create -d macvlan --subnet=192.168.0.0/24 --gateway=192.168.0.254 --ipv6 --subnet=fe81::/16 --gateway=fe81::1 -o parent=ens34 -o macvlan_mode=bridge openwrt-WAN

#docker network create -d macvlan --subnet=172.16.60.0/24 --gateway=172.16.60.254  -o parent=ens33 -o macvlan_mode=bridge openwrt-LAN

systemctl start docker
systemctl enable docker
systemctl disable docker

docker network create -d macvlan --subnet=192.168.10.0/24 --gateway=192.168.10.1  -o parent=eth0 -o macvlan_mode=bridge openwrt-WAN

#imprt docker
docker import openwrt-x86-64-generic-rootfs.tar.gz lean_openwrt

docker stop openwrt && docker rm openwrt
#start --ip=192.168.10.10 
docker run -it -d --restart always --network openwrt-WAN -p 80:422 --privileged --name openwrt lean_openwrt /sbin/init

docker stop openwrt && docker rm openwrt
#docker run -it -d --restart always --ip=192.168.10.10 --privileged --name openwrt /sbin/init

docker stop openwrt && docker rm openwrt
docker run -it -d --restart always --ip="192.168.10.10"  -p 422:80 --privileged --name openwrt lean_openwrt /sbin/init

docker run -it -d --restart always --ip="192.168.10.10"  -p 0.0.0.0:422:80/tcp --privileged --name openwrt lean_openwrt /sbin/init
docker run -it -d --restart always --ip="192.168.10.10"  -p 0.0.0.0:422:80/tcp --name openwrt lean_openwrt /sbin/init


docker stop openwrt && docker rm openwrt
docker exec -it openwrt /bin/sh
# 	
docker network create -d macvlan --subnet=192.168.6.5/24 --gateway=192.168.6.1 -o parent=eth0 openwrt_wan
docker stop openwrt && docker rm openwrt
docker run -it -d --restart always  -p 0.0.0.0:422:80 --network openwrt_wan --name openwrt lean_openwrt /sbin/init

docker run -it -d --restart always  --network openwrt_wan -p 0.0.0.0:422:80 --privileged --name openwrt lean_openwrt /sbin/init

docker ps
ad8623bd77e0 

	
docker exec -it ad8623bd77e0 sh
vi /etc/config/network

/etc/init.d/network restart
# #####docker run -it -d --restart always -p 0.0.0.0:422:80/tcp --name openwrt lean_openwrt /sbin/init

ip route add 192.168.10.2/24 via 173.82.238.51
ip addr del 192.168.10.0/24 dev docker0; 

route del 192.168.10.0/24 dev docker0

route add -net 192.168.10.1/24 gw 173.82.238.51

ip route add 192.168.10.0/24 dev docker0
ip route del 192.168.10.0 

route add -net 192.168.10.0/24  gw 173.82.238.51

docker run -it -d --restart always  -p 0.0.0.0:422:80 --privileged --name openwrt lean_openwrt /sbin/init

# go to docker
docker exec -it openwrt /bin/sh

docker network create -d macvlan --subnet 192.168.10.1/24 --gateway 192.168.10.1 -o parent=eth0 dknet1
sysctl -w net.ipv4.ip_forward=1


sudo brctl addbr docker0
sudo ip addr add 192.168.10.1/24 dev docker0
sudo ip link set dev docker0 up

vi /etc/docker/daemon.json

{"registry-mirrors": ["http://224ac393.m.daocloud.io"],
    "bip": "192.168.10.1/24"
}

{
	"bip": "192.168.10.1/24",
    "mtu": 1500,
    "default-gateway": "192.168.10.1",
    "dns": ["8.8.8.8","8.8.4.4"]
}

 ip addr show docker0
service docker stop
 brctl show
 ip addr show bridge0

ip link set dev docker0 down
ip addr del 172.17.0.1/16 dev docker0

sudo yum install -y bridge-utils

brctl addbr bridge0
ip addr add 192.168.10.1/24 dev bridge0
ip link set dev bridge0 up

brctl addbr docker0
ip addr add 192.168.10.1/24 dev docker0
ip link set dev docker0 up


ip addr show bridge0

# 4.修改配置文件
/etc/docker/daemon.json（如不存在则创建一个 touch daemon.json）,使Docker启动时使用自定义网桥
vi /etc/docker/daemon.json（
{
  "bridge": "bridge0"
}


ip addr add 192.168.10.1/24 dev docker0
ip link set dev docker0 up


systemctl start docker

journalctl -f -u docker
dockerd


# 检测是否配置成功，如果输出信息中有 192.168.5.1，则表明成功
ip addr show docker0
service docker start

service docker restart
ip link set dev docker0 down
 
brctl delbr docker0
brctl delbr bridge0

echo 'DOCKER_OPTS="-b=bridge0"' >> /etc/sysconfig/docker
sudo service docker start


ifconfig eth0 192.168.10.1 netmask 255.255.255.0 up

#编辑 /etc/config/network

config interface 'wan'
        option ifname 'eth0.2'  
        option proto 'static'
        option ipaddr '192.168.10.10'
        option netmask '255.255.255.0'
        option gateway '192.168.10.2'


/etc/init.d/network restart



#add router
ip addr del 192.168.10.1/24 dev eth0; \
ip link add macvlan link eth0 type macvlan mode bridge; \
ip addr add 192.168.10.1/24 dev macvlan; \
ip link set macvlan up; \
ip route del 192.168.10.0/24 dev eth0; \
ip route del default; \
ip route add 192.168.10.0/24 dev macvlan; \
ip route add default via 192.168.10.1 dev macvlan;


242

default         216.127.173.241 0.0.0.0         UG    0      0        0 eth0
216.127.173.240 0.0.0.0         255.255.255.240 U     0      0        0 eth0

ip route del default;

ip route add 173.82.238.0/24 dev eth0;
ip route add default via 173.82.238.50 dev eth0;



docker network create -d macvlan \
    --subnet=10.1.1.0/24 --gateway=10.1.1.1 \
    --ipv6 --subnet=fe80::/16 --gateway=fe80::1 \
    -o parent=enp3s0 \
    -o macvlan_mode=bridge \
    dMACvLAN
# WAN 口
docker network create -d macvlan \
    --subnet=192.168.254.0/24 --gateway=192.168.254.1 \
    --ipv6 --subnet=fe81::/16 --gateway=fe81::1 \
    -o parent=enp1s0 \
    -o macvlan_mode=bridge \
    dMACvWAN

```