# Virtual-laboratory
ローカルのマシンに仮想の研究室サーバクラスタを構築します。<br>
4 ノードでクラスタを構築します。<br>
各ノードは物理マシンでも，仮想マシンでも可能

## 仕様書
### サーバ
- ノード 1： (node090)
    - **外部からのエントリポイント**
    - 踏み台サーバ
    - 192.168.122.11/24
    - ansible
        - ターゲットノード
    - 主にルーティングの設定
        - `ssh node02 -J node01`で内部クラスタに入る
        - `ssh node02`では入れない
- ノード 2： (node091)
    - **ストレージサーバ**
    - 192.168.122.12/24
    - ansible
        - コントロールノード
    - k8s 
        - マスタ
    - LDAP，samba，NFS
        - サーバ
- ノード 3： (node100)
    - **計算ノード**
    - 192.168.122.13/24
    - ansible 
        - ターゲット
    - k8s 
        - ワーカ
    - LDAP，NFS
        - クライアント
- ノード4： (node101)
    - **計算ノード**
    - 192.168.122.14/24
    - ansible 
        - ターゲット
    - k8s 
        - ワーカ
    - LDAP，NFS
        - クライアント

## ユーザ
- admin
    - home: /home/admin
    - group: admin, sudo
    - pass: adminpass
- user1
    - home: /home/user1
    - group: user1
    - user1pass
- user2
    - home: /home/user2
    - group: user2
    - user2pass

## Quick Start
- 各ノードにpython3をインストールしてください
```sh
# node2
sudo apt install -y python3
sudo ln -s /usr/bin/python3 /usr/bin/python
```

```sh
git clone <this repo>
cd virt-lab
./install.sh
```
```sh
# node2
ssy-keygen
# node1
scp ssh.sh id_rsa.pub 192.168.122.11:$HOME/
ssh 192.168.122.11 $HOME/ssh.sh
# node3
scp ssh.sh id_rsa.pub 192.168.122.13:$HOME/
ssh 192.168.122.13 $HOME/ssh.sh
# node4
scp ssh.sh id_rsa.pub 192.168.122.14:$HOME/
ssh 192.168.122.14 $HOME/ssh.sh
```


## メモ
### ansibleのインストール (pip ver)
```sh
sudo apt install -y python3-virtualenv python3-pip
# 仮想環境の作成
virtualenv virenv
# 有効化
source virenv/bin/activate
# 無効化
deactivate
# 仮想環境にansibleをインストール
source virenv/bin/activate
pip3 install ansible==2.9.6
```

```sh

```