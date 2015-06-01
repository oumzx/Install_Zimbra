#!/bin/sh
ALIAS="mail" #Ne pas changer 
DOMAINE="sanogo.net"

cd /tmp/
wget wget http://passidiweb.site50.net/Script/get_plat_tag.sh
chmod 777 get_plat_tag.sh

PLATFORM=`./get_plat_tag.sh`
if [ $PLATFORM = "RHEL7_64" ]; then 

	wget http://passidiweb.site50.net/Script/Zimbra_Install_RHEL.sh
	chmod 777 Zimbra_Install_RHEL.sh
	./Zimbra_Install_RHEL.sh $ALIAS $DOMAINE
	rm -rf Zimbra_Install_RHEL.sh
fi

if [ $PLATFORM = "UBUNTU" ]; then 

	wget http://passidiweb.site50.net/Script/Zimbra_Install_UBUNTU.sh
	chmod 777 Zimbra_Install_UBUNTU.sh
	./Zimbra_Install_UBUNTU.sh $ALIAS $DOMAINE
	rm -rf Zimbra_Install_UBUNTU
fi

rm -rf get_plat_tag.sh
