#!/bin/bash

ansible-playbook -bK -i inv.ini play-ldap.yml

ansible-playbook -bK -i inv.ini play-tls-serv.yml
ansible-playbook -bK -i inv.ini play-sssd-serv.yml

ansible-playbook -bK -i inv.ini play-tls-calc.yml
ansible-playbook -bK -i inv.ini play-sssd-calc.yml

ansible-playbook -bK -i inv.ini play-nfs-serv.yml
ansible-playbook -bK -i inv.ini play-nfs-calc.yml

ansible-playbook -bK -i \
    inv.ini play-ldap.yml \
    inv.ini play-tls-serv.yml \
    inv.ini play-tls-calc.yml \
    inv.ini play-sssd-serv.yml \
    inv.ini play-sssd-calc.yml \
    inv.ini play-nfs-serv.yml \
    inv.ini play-nfs-calc.yml