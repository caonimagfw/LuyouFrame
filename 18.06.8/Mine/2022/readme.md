# Manual Command 

## Install tools and Get files
```
yum -y install epel-release
yum -y install wget 
systemctl stop firewalld
yum -y install firewalld && yum -y upgrade firewalld
systemctl enable firewalld && systemctl restart firewalld

# get files

wget https://raw.githubusercontent.com/caonimagfw/LuyouFrame/master/18.06.8/Mine/2022/one.sh
wget https://raw.githubusercontent.com/caonimagfw/LuyouFrame/master/18.06.8/Mine/2022/two.sh

# run install core 5.10.0
bash one.sh ######

# set base env ${1} ${2}
bash two.sh init ######

# final run ${1} ${2}
bash two.sh d4 ######
bash two.sh d6 ######

```

## Other Info
```
nameserver 8.8.8.8
nameserver 8.8.4.4
nameserver 2001:4860:4860::8888
nameserver 2001:4860:4860::8844

```
