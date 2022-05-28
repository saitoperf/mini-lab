#!/bin/bash

mkdir -p ${HOME}/.ssh
chmod 700 ${HOME}/.ssh

cat ${HOME}/id_rsa.pub >> ${HOME}/.ssh/authorized_keys
rm ${HOME}/id_rsa.pub
chmod 600 ${HOME}/.ssh/authorized_keys
