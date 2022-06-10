# one.sh

#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

Green_font_prefix="\033[32m"
Red_font_prefix="\033[31m"
Green_background_prefix="\033[42;37m"
Red_background_prefix="\033[41;37m"
Font_color_suffix="\033[0m"

Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"

#优化系统配置
optimizing_system_v2(){
	modprobe ip_conntrack
	echo "
fs.file-max = 1024000
fs.inotify.max_user_instances = 8192
net.core.netdev_max_backlog = 262144
net.core.rmem_default = 8388608
net.core.rmem_max = 67108864
net.core.somaxconn = 65535
net.core.wmem_default = 8388608
net.core.wmem_max = 67108864
net.ipv4.ip_local_port_range = 10240 65000
net.ipv4.route.gc_timeout = 100
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time=60
net.ipv4.tcp_keepalive_intvl=5
net.ipv4.tcp_keepalive_probes=3
net.ipv4.tcp_max_orphans = 3276800
net.ipv4.tcp_max_syn_backlog = 65536
net.ipv4.tcp_max_tw_buckets = 60000
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_rmem = 8192 87380 67108864
net.ipv4.tcp_sack = 1
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_wmem = 8192 65536 67108864
net.netfilter.nf_conntrack_max = 6553500
net.netfilter.nf_conntrack_tcp_timeout_close_wait = 60
net.netfilter.nf_conntrack_tcp_timeout_established = 3600
net.netfilter.nf_conntrack_tcp_timeout_fin_wait = 120
net.netfilter.nf_conntrack_tcp_timeout_time_wait = 120
net.nf_conntrack_max = 6553500
net.ipv4.ip_forward = 1
net.ipv4.icmp_echo_ignore_all=1

">>/etc/sysctl.conf
	sysctl -p
	echo "*               soft    nofile           1000000
*               hard    nofile          1000000">/etc/security/limits.conf
	echo "ulimit -SHn 1000000">>/etc/profile
}

startbbrV2(){
	: > /etc/sysctl.conf
	echo "net.core.default_qdisc=fq_pie" >>/etc/sysctl.d/99-sysctl.conf
  	echo "net.ipv4.tcp_congestion_control=bbr2" >>/etc/sysctl.d/99-sysctl.conf
	sysctl --system
	sysctl -p
	echo -e "${Info}BBR V2 and fq_pie 启动成功！"
}

detele_kernel_for_bbr(){
	kernel_version="5.10.0"
	if [[ "${release}" == "centos" ]]; then
		rpm_total=`rpm -qa | grep kernel | grep -v "${kernel_version}" | grep -v "noarch" | wc -l`
		if [ "${rpm_total}" > "1" ]; then
			echo -e "检测到 ${rpm_total} 个其余内核，开始卸载..."
			for((integer = 1; integer <= ${rpm_total}; integer++)); do
				rpm_del=`rpm -qa | grep kernel | grep -v "${kernel_version}" | grep -v "noarch" | head -${integer}`
				echo -e "开始卸载 ${rpm_del} 内核..."
				rpm --nodeps -e ${rpm_del}
				echo -e "卸载 ${rpm_del} 内核卸载完成，继续..."
			done
			echo -e "内核卸载完毕，继续..."
		else
			echo -e " 检测到 内核 数量不正确，请检查 !" && exit 1
		fi
	elif [[ "${release}" == "debian" || "${release}" == "ubuntu" ]]; then
		deb_total=`dpkg -l | grep linux-image | awk '{print $2}' | grep -v "${kernel_version}" | wc -l`
		if [ "${deb_total}" > "1" ]; then
			echo -e "检测到 ${deb_total} 个其余内核，开始卸载..."
			for((integer = 1; integer <= ${deb_total}; integer++)); do
				deb_del=`dpkg -l|grep linux-image | awk '{print $2}' | grep -v "${kernel_version}" | head -${integer}`
				echo -e "开始卸载 ${deb_del} 内核..."
				apt-get purge -y ${deb_del}
				echo -e "卸载 ${deb_del} 内核卸载完成，继续..."
			done
			echo -e "内核卸载完毕，继续..."
		else
			echo -e " 检测到 内核 数量不正确，请检查 !" && exit 1
		fi
	fi
}

installbbrv2(){
	wget https://github.com/caonimagfw/onefast/raw/master/bbr/centos/5.10.0.x86-64/5.10.0.x86-64.part1.rar
	wget https://github.com/caonimagfw/onefast/raw/master/bbr/centos/5.10.0.x86-64/5.10.0.x86-64.part2.rar
	wget https://github.com/caonimagfw/onefast/raw/master/bbr/centos/5.10.0.x86-64/5.10.0.x86-64.part3.rar
	wget https://github.com/caonimagfw/onefast/raw/master/bbr/centos/5.10.0.x86-64/5.10.0.x86-64.part4.rar
	wget https://github.com/caonimagfw/onefast/raw/master/bbr/centos/5.10.0.x86-64/5.10.0.x86-64.part5.rar
	unrar x -p${1} -D 5.10.0.x86-64.part1.rar && rm -rf 5.10.0.x86-64.p*
	yum install -y /root/5.10.0.x86-64/kernel-5.10.0.x86_64.rpm
	
	detele_kernel_for_bbr
	
	grub2-set-default 'CentOS Linux (5.10.0) 7 (Core)'
	grub2-editenv list
	startbbrV2
	optimizing_system_v2
	echo -e "${Tip} 重启VPS后，请重新运行脚本开启${Red_font_prefix}BBR V2${Font_color_suffix}"
	stty erase '^H' && read -p "需要重启VPS后，才能开启BBR V2，是否现在重启 ? [Y/n] :" yn
	[ -z "${yn}" ] && yn="y"
	if [[ $yn == [Yy] ]]; then
		echo -e "${Info} VPS 重启中..."
		reboot
	fi
}

mainRun(){
	modprobe ip_conntrack

	wget https://github.com/caonimagfw/onefast/raw/master/rarlinux-x64-5.5.0.tar.gz
	tar -zxvf rarlinux-x64-5.5.0.tar.gz
	cd rar
	sudo cp -v rar unrar /usr/local/bin/
	cd ..

	installbbrv2
}

####系统检测组件####
checkRelease
checkReleaseVersion

if [[ ${release} == "debian" || ${release} == "ubuntu" || ${release} == "centos" ]]; then
	mainRun
else
	echo -e "${Error} 本脚本不支持当前系统 ${release} !"
	exit 1
fi
