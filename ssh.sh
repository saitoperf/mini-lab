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

if [ ! -e ${HOME}/.ssh/id_rsa || ! -e ${HOME}/.ssh/id_rsa.pub ]; then
    rm ${HOME}/.ssh/id_rsa.pub ${HOME}/.ssh/id_rsa
    ssh-keygen
    # コントロールノードに手元のマシンの公開鍵を入れておくと
    # ターゲットにも手元のマシンから公開鍵認証できるようになります。
    cat ${HOME}/.ssh/authorized_keys >> ${HOME}/.ssh/id_rsa.pub
fi

# Change your node's account
USR="taiki"
# Change your node's IP
## hack11
func 133.15.45.42
## hack12
func 133.15.45.43
## hack21
func 133.15.45.45
## hack21
func 133.15.45.46
