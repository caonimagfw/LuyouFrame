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