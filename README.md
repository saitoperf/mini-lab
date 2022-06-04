# mini-lab
ローカルのマシンに仮想の研究室サーバクラスタを構築します。<br>
4 ノードでクラスタを構築します。<br>
各ノードは物理マシンでも，仮想マシンでも可能


## リポジトリ構成
- src
    - ソースコード置き場
    - 主にansible
- memo
    - サーバ構築のメモ
- plan.md
    - 作業計画
- install.sh
    - インストーラ

## 仕様書
### サーバ
- ノード 1： (hack11)
    - **外部からのエントリポイント**
    - 踏み台サーバ
    - 133.15.45.42/25
    - ansible
        - ターゲットノード
    - 主にルーティングの設定
        - `ssh hack12 -J hack11`で内部クラスタに入る
        - `ssh hack12`では入れない
- ノード 2： (hack12)
    - **ストレージサーバ**
    - 133.15.45.43/25
    - ansible
        - ターゲットノード
    - k8s 
        - マスタ
    - LDAP，samba，NFS
        - サーバ
- ノード 3： (hack21)
    - **計算ノード**
    - 133.15.45.45/25
    - ansible 
        - ターゲット
    - k8s 
        - ワーカ
    - LDAP，NFS
        - クライアント
- ノード4： (hack22)
    - **計算ノード**
    - 133.15.45.46/25
    - ansible 
        - ターゲット
    - k8s 
        - ワーカ
    - LDAP，NFS
        - クライアント

### LDAPユーザ
- admin
    - home: /home/admin
    - group: admin, sudo
    - pass: pass
- user1
    - home: /home/user01
    - group: user01
    - user01
- user2
    - home: /home/user02
    - group: user02
    - user02

## Quick Start
- 各ノードにpython3をインストールしてください
```sh
# hack12
sudo apt install -y python3
sudo ln -s /usr/bin/python3 /usr/bin/python
```

```sh
git clone https://github.com/saitoperf/virt-lab.git
cd virt-lab
./install.sh
```