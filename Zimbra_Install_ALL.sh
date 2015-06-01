#!/bin/sh

#Variable à modifier
ALIAS="mail" #Ne pas changer 
DOMAINE="domaine.net" #

chmod 777 get_plat_tag.sh

PLATFORM=`./get_plat_tag.sh`
if [ $PLATFORM = "RHEL7_64" ]; then 

	chmod 777 Zimbra_Install_RHEL.sh
	./Zimbra_Install_RHEL.sh $ALIAS $DOMAINE
fi

if [ $PLATFORM = "UBUNTU" ]; then 

	chmod 777 Zimbra_Install_UBUNTU.sh
	./Zimbra_Install_UBUNTU.sh $ALIAS $DOMAINE
fi

