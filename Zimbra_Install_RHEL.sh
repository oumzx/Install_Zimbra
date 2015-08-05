#!/bin/sh

#Passidi DIAW
clear

echo "##################################################################################"
echo "# Zimbra Auto Script ver 0.1 CENTOS 7.1                                		    #"
echo "# Script d'automatisation de Zimbra Mail Server 8.6 GA CENTOS 7.1             	#"
echo "# Passidi Diaw - support@veone - http://veone.net									#"
echo "# License : GPL, General Public License					       					#"
echo "##################################################################################"

echo "Variable"

ALIAS=$1 #Ne pas changer 
DOMAINE=$2
echo "ALIAS   :" $ALIAS
echo "DOMAINE :" $DOMAINE
IP=$(ifconfig eth0 | awk ' /inet / { print $2 } ')

MDP="Admincloud"
#/etc/init.d/gandi-mount restart

echo "Script d'automatisation de Zimbra Mail Server 8.6 GA CENTOS 7.1  :"
echo "1. Configure Update Upgrade"

yum update -qy
echo "2. install Configure Requirements "


yum install sysstat wget nmap-ncat libaio unzip perl-core -qy

systemctl disable postfix.service
systemctl stop postfix.service
systemctl disable httpd.service
systemctl stop  httpd.service


chkconfig postfix off
service postfix stop
chkconfig httpd off
service httpd stop

echo "3. Downloads zimbra"

pushd /tmp 
wget https://files.zimbra.com/downloads/8.6.0_GA/zcs-8.6.0_GA_1153.RHEL7_64.20141215151110.tgz



echo "6. Unzip / fichier d'installation Zimbra"

tar xvzf zcs-8.6.0_GA_1153.RHEL7_64.20141215151110.tgz

echo "7. Install Zimbra "

#cd ./zcs-8.6.0_GA_1153.RHEL7_64.20141215151110

#mv -vf install.sh install.sh.bak
mv -vf /tmp/zcs-8.6.0_GA_1153.RHEL7_64.20141215151110/install.sh /tmp/zcs-8.6.0_GA_1153.RHEL7_64.20141215151110/install.sh.bak

popd

cp -rvp ./util/utilfunc.sh /tmp/zcs-8.6.0_GA_1153.UBUNTU14_64.20141215151116/util/utilfunc.sh
cp -rvp ./util/globals.sh  /tmp/zcs-8.6.0_GA_1153.UBUNTU14_64.20141215151116/util/globals.sh
cp -rvp install.sh /tmp/zcs-8.6.0_GA_1153.UBUNTU14_64.20141215151116/install.sh
chmod 777 install.sh

hostname $ALIAS.$DOMAINE
HOST=$(hostname)
VAR=$(echo $IP  $HOST $ALIAS)
sed -i "s/$IP.*$/$VAR/g" /etc/hosts
#echo $VAR >> /etc/hosts 

./install.sh --platform-override

#Config Done
 
exit
echo ""
echo "Installation Zimbra terminée "
echo "Mot de passe Administrateur : Admincloud"

