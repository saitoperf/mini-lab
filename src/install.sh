#!/bin/bash

#source ./ssh.sh
ansible -i ./src/inv.ini ./play-ldap.yml -bK
ansible -i ./src/inv.ini ./play-tls-serv.yml -bK
ansible -i ./src/inv.ini ./play-tls-calc.yml -bK
ansible -i ./src/inv.ini ./play-sssd-serv.yml -bK
ansible -i ./src/inv.ini ./play-sssd-calc.yml -bK
ansible -i ./src/inv.ini ./play-nfs-serv.yml -bK
ansible -i ./src/inv.ini ./play-nfs-calc.yml -bK
ansible -i ./src/inv.ini ./play-samba.yml -bK
