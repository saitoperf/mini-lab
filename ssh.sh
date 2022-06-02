#!/bin/bash

func(){
    # copy public-key
    ssh ${USR}@$1 mkdir ${HOME}/.ssh
    scp ${HOME}/.ssh/id_rsa.pub ${USR}@$1:/home/${USR}/.ssh

    # rename public-key to authorized_keys
    ssh ${USR}@$1 mv ${HOME}/.ssh/id_rsa.pub ${HOME}/.ssh/authorized_keys
    
    # chmod dir and file
    ssh ${USR}@$1 chmod 700 ${HOME}/.ssh
    ssh ${USR}@$1 chmod 600 ${HOME}/.ssh/authorized_keys
}

if [ ! -e ${HOME}/.ssh/id_rsa.pub ]; then
    ssh-keygen
fi
# Change your node's account
USR="saito"
# Change your node's IP
func 133.15.45.42
# func 133.15.45.43
func 133.15.45.45
func 133.15.45.46
