#!/bin/sh

#Passidi DIAW
clear

echo "##################################################################################"
echo "# Zimbra Auto Script ver 0.1 Ubuntu 14.04 LTS                                		#"
echo "# Script d'automatisation de Zimbra Mail Server 8.6 GA Ubuntu 14.04 LTS        	#"
echo "# Passidi Diaw - support@veone - http://veone.net									#"
echo "# License : GPL, General Public License					       					#"
echo "##################################################################################"

echo "Variable"
CHM=$(pwd)
ALIAS=$1
DOMAINE=$2
echo "ALIAS   :" $ALIAS
echo "DOMAINE :" $DOMAINE
IP=$(ifconfig eth0 | awk ' /addr:/ { print $2 } ' | awk -F':' ' { print $2}' )

MDP="Admincloud"
/etc/init.d/gandi-mount restart

echo "Script d'automatisation de Zimbra Mail Server 8.6 GA Ubuntu 14.04 LTS  :"
echo "1. Configure Update Upgrade"

apt-get update && apt-get upgrade -qy

echo "2. install Configure Requirements "



#echo $IP  $HOST>> /etc/hosts

#apt-get install libgmp3-dev -qy
apt-get -y install libgmp10 libperl-dev libperl5.18 libaio1 unzip pax sysstat sqlite3 netcat-openbsd sudo -qy
#apt-get install libgmp3c2 libperl-dev pax sysstat sqlite3 -qy (ubuntu 12.04)

echo "3. Downloads zimbra"

cd /tmp 
wget https://files.zimbra.com/downloads/8.6.0_GA/zcs-8.6.0_GA_1153.UBUNTU14_64.20141215151116.tgz

echo "6. Unzip / fichier d'installation Zimbra"

tar xvzf zcs-8.6.0_GA_1153.UBUNTU14_64.20141215151116.tgz

echo "7. Install Zimbra "

#cd ./zcs-8.6.0_GA_1153.UBUNTU14_64.20141215151116

apt-get install dnsmasq -qy
apt-get install resolvconf -qy

#mv -vf install.sh install.sh.bak
mv -vf /tmp/zcs-8.6.0_GA_1153.UBUNTU14_64.20141215151116/install.sh /tmp/zcs-8.6.0_GA_1153.UBUNTU14_64.20141215151116/install.sh.bak

cd $CHM

cp -rvp ./util/utilfunc.sh /tmp/zcs-8.6.0_GA_1153.UBUNTU14_64.20141215151116/util/utilfunc.sh
cp -rvp ./util/globals.sh  /tmp/zcs-8.6.0_GA_1153.UBUNTU14_64.20141215151116/util/globals.sh
cp -rvp ./setup/zmsetup.pl /tmp/zcs-8.6.0_GA_1153.UBUNTU14_64.20141215151116/
cp -rvp ./setup/postinstall.pm /tmp/zcs-8.6.0_GA_1153.UBUNTU14_64.20141215151116/
cp -rvp install.sh /tmp/zcs-8.6.0_GA_1153.UBUNTU14_64.20141215151116/install.sh
chmod 777 install.sh

hostname $ALIAS.$DOMAINE
HOST=$(hostname)
VAR=$(echo $IP  $HOST $ALIAS)
sed -i "s/$IP.*$/$VAR/g" /etc/hosts
grep ^$VAR$ /etc/hosts
codeRetour=$?
if [ "$codeRetour" = 1 ]; then
echo $VAR >> /etc/hosts 
fi

cd /tmp/zcs-8.6.0_GA_1153.UBUNTU14_64.20141215151116/
./install.sh 

#Config Done
 
exit
echo ""
echo "Installation Zimbra terminée "
echo "Mot de passe Administrateur : Admincloud"

