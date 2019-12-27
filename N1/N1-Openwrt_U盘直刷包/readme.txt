url:https://www.right.com.cn/forum/thread-981406-1-1.html

本帖最后由 flippy 于 2019-12-25 12:55 编辑

本帖最后由 flippy 于 2019-12-25 12:55 编辑


使用说明：
默认IP： 192.168.1.1   默认密码： password
注：如果用这个固件做旁路由的话不要忘了加自定义防火墙规则（网络->防火墙->自定义规则）：
iptables -t nat -I POSTROUTING -o eth0 -j MASQUERADE
Docker 安装配置 Adguardhome 的教程见 1746楼


N1用法： 用U盘镜像文件写入工具，把img文件写入U盘， U盘直接启动（不需要借助Armbian)， 电脑设置静态ip 192.168.1.x (x != 1) ， 能ping通192.168.1.1就可以使用了
                第一次写入emmc:    U盘启动后， ssh工具连入 192.168.1.1， 运行 :

cd /root
./inst-to-emmc.sh
复制代码
                升级新版本到emmc（不丢配置）： U盘启动后，ssh工具连入 192.168.1.1，运行:
cd /root
./update-to-emmc.sh
复制代码
（N1不支持RTL8153，但支持AX88179，速率200m左右, 不建议外接网卡，直接用单网卡做旁路由也能达到750m左右）

（另外，根据网友的反馈，个别情况：主路由采用padavan及开启硬加速， 而用N1做旁路由时可能出现不兼容情况，导致网络卡顿，关闭主路由硬加速可以解决。详情见698楼。）