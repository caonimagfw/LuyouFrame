# Manual Command 

## Install tools and Get files
```
yum -y install epel-release
yum -y install wget 
yum -y install firewalld && systemctl start firewalld

# get files

wget --no-check-certificate -O one.sh https://raw.githubusercontent.com/caonimagfw/onefast/master/18.06.8/Mine/2022/one.sh
wget --no-check-certificate -O two.sh https://raw.githubusercontent.com/caonimagfw/onefast/master/18.06.8/Mine/2022/two.sh

# run install core 5.10.0
bash one.sh ######

# set base env ${1} ${2}
bash two.sh init ######

# final run ${1} ${2}
bash two.sh d4 ######
bash two.sh d6 ######

```
