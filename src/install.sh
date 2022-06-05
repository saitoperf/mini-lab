#!/bin/bash

ansible-playbook -bK -i inv.ini play-ldap.yml

ansible-playbook -bK -i inv.ini play-tls-serv.yml
ansible-playbook -bK -i inv.ini play-sssd-serv.yml

ansible-playbook -bK -i inv.ini play-tls-calc.yml
ansible-playbook -bK -i inv.ini play-sssd-calc.yml

ansible-playbook -bK -i inv.ini play-nfs-serv.yml
ansible-playbook -bK -i inv.ini play-nfs-calc.yml

ansible-playbook -bK -i inv.ini play-k8s-m.yml
ansible-playbook -bK -i inv.ini play-k8s-w.yml
ansible-playbook -bK -i inv.ini play-k8s-prom.yml


ansible-playbook -bK -i \
    inv.ini play-ldap.yml \
    inv.ini play-tls-serv.yml \
    inv.ini play-tls-calc.yml \
    inv.ini play-sssd-serv.yml \
    inv.ini play-sssd-calc.yml \
    inv.ini play-nfs-serv.yml \
    inv.ini play-nfs-calc.yml

# スナップショットの復元
virsh snapshot-revert --domain node090 --snapshotname init_v1
virsh snapshot-revert --domain node091 --snapshotname init
virsh snapshot-revert --domain node092 --snapshotname init_v1
virsh snapshot-revert --domain node093 --snapshotname init_v1