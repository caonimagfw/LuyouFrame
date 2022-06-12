# two.sh

#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

pa2=$2

init(){
    systemctl start firewalld
    modprobe ip_conntrack
    sysctl net.ipv4.tcp_available_congestion_control
    sysctl net.ipv4.tcp_congestion_control
    sysctl net.core.default_qdisc
    lsmod | grep bbr
    # set ssh port
    # #Port 22
    sed -i.bak '0,/#Port 22/s//Port 58899/' /etc/ssh/sshd_config
    firewall-cmd --zone=public --add-port=58899/tcp --permanent
    firewall-cmd --reload && firewall-cmd --permanent --list-all --zone=public
    systemctl restart sshd
    yum provides semanage
    yum -y install policycoreutils-python
    semanage port -a -t ssh_port_t -p tcp 58899
    semanage port -l | grep ssh
    semanage port -d -t ssh_port_t -p tcp 22
    semanage port -l | grep ssh
    systemctl start firewalld
    firewall-cmd --zone=public --remove-port=22/tcp --permanent && firewall-cmd --reload 
    firewall-cmd --zone=trusted --remove-port=22/tcp --permanent && firewall-cmd --reload 

    # set all firewall 
    #systemctl stop firewalld && yum -y upgrade firewalld
    #systemctl enable firewalld && systemctl restart firewalld
    firewall-cmd --permanent --zone=public --add-port=10111/tcp 
    firewall-cmd --permanent --zone=public --add-port=20677/tcp --add-port=20688/tcp
    firewall-cmd --permanent --zone=public --add-port=30677/tcp --add-port=30688/tcp
    firewall-cmd --permanent --zone=public --add-port=40677/tcp --add-port=40688/tcp
    firewall-cmd --permanent --zone=public  --add-forward-port=port=20677:proto=tcp:toport=10111
    firewall-cmd --permanent --zone=public  --add-forward-port=port=20688:proto=tcp:toport=10111
    firewall-cmd --permanent --zone=public  --add-forward-port=port=30677:proto=tcp:toport=10111
    firewall-cmd --permanent --zone=public  --add-forward-port=port=30688:proto=tcp:toport=10111
    firewall-cmd --permanent --zone=public  --add-forward-port=port=40677:proto=tcp:toport=10111
    firewall-cmd --permanent --zone=public  --add-forward-port=port=40688:proto=tcp:toport=10111
    firewall-cmd --permanent --zone=public  --add-masquerade 
    firewall-cmd --permanent --zone=trusted --add-masquerade
    firewall-cmd --permanent --zone=public --direct --add-rule ipv4 filter INPUT_direct 0 -p tcp --tcp-flags RST,RST RST -j DROP	
    firewall-cmd --permanent --zone=public --direct --add-rule ipv4 filter INPUT 0 -p tcp --tcp-flags RST,RST RST -j DROP	
    firewall-cmd --permanent --zone=trusted --direct --add-rule ipv4 filter INPUT_direct 0 -p tcp --tcp-flags RST,RST RST -j DROP	
    firewall-cmd --permanent --zone=trusted --direct --add-rule ipv4 filter INPUT 0 -p tcp --tcp-flags RST,RST RST -j DROP	
    firewall-cmd --reload
    #install all tools and caddy yum install bind-utils -y
    yum -y install wget net-tools bridge-utils && yum -y install epel-release && yum -y install unar
    wget --no-check-certificate -O caddy_install.sh https://raw.githubusercontent.com/caonimagfw/Caddy/master/caddy_install.sh && bash caddy_install.sh
cat > /usr/local/caddy/Caddyfile <<-EOF
	:8099 {
		root /usr/local/caddy/www
		gzip
	}
EOF
    cat /usr/local/caddy/Caddyfile 
    service caddy restart 
    #docker 
    yum install -y yum-utils device-mapper-persistent-data lvm2
    yum-config-manager \
        --add-repo \
        https://download.docker.com/linux/centos/docker-ce.repo
    yum makecache fast
    yum list docker-ce --showduplicates | sort -r
    yum -y install docker-ce-20.10.16 docker-ce-cli-20.10.16 containerd.io
    systemctl enable docker.socket --now
    systemctl enable docker && systemctl restart docker  

    sed -i.bak 's/^After=.*/After=containerd.service/g' /etc/systemd/system/multi-user.target.wants/docker.service
    sed -i.bak 's/^Wants=.*/Wants=containerd.service/g' /etc/systemd/system/multi-user.target.wants/docker.service
    sed -i.bak 's/^Requires=.*/#/g' /etc/systemd/system/multi-user.target.wants/docker.service

    mkdir /root/docker && cd /root/docker
    wget --no-check-certificate  https://github.com/caonimagfw/LuyouFrame/raw/master/18.06.8/Mine/2021/trojan-gnu.rar
    unar -D -p ${pa2} trojan-gnu.rar && rm -rf *.rar 
    docker import trojan-gnu.tar trojan-gnu
}

d4(){
    docker run --name trojan-gnu-r -itd --restart=unless-stopped --network host trojan-gnu /usr/local/bin/tr-gnu 0.0.0.0:10111 ${pa2} -t 10 -d 8.8.4.4 -c /etc/trojan/server.cert.pem -k /etc/trojan/server.key.pem -s TLS13_CHACHA20_POLY1305_SHA256
}

d6(){
    docker run --name trojan-gnu-r -itd --restart=unless-stopped --network host trojan-gnu /usr/local/bin/tr-gnu 0.0.0.0:10111 ${pa2} -t 10 -c /etc/trojan/server.cert.pem -k /etc/trojan/server.key.pem -s TLS13_CHACHA20_POLY1305_SHA256
}
ds(){
	sysctl net.ipv4.tcp_available_congestion_control
	sysctl net.ipv4.tcp_congestion_control
	sysctl net.core.default_qdisc
	lsmod | grep bbr
}


if [[ ${1} == "d4" ]]; then
    d4
fi

if [[ ${1} == "d6" ]]; then
    d6
fi
if [[ ${1} == "s" ]]; then
    ds
fi


if [[ ${1} == "init" ]]; then 
    init
fi 
