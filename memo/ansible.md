# ansible
- [Ansible日本語ドキュメント](https://docs.ansible.com/ansible/2.9_ja/index.html)
- [Ansibleドキュメント](https://docs.ansible.com/ansible/latest/index.html)

## 対話型
- dpkg-reconfigure で対話になる問題
- 解決策
    - https://github.com/nonlinear-vegan/slapd/blob/master/Dockerfile
    - shellモジュールを使ってワンライナーで書く
```yaml
    shell: sudo echo "slapd slapd/no_configuration boolean false" | sudo debconf-set-selections && sudo echo "slapd slapd/domain string example.com" | sudo debconf-set-selections && sudo echo "slapd shared/organization string 'admin'" | sudo debconf-set-selections && sudo echo "slapd slapd/password1 password pass" | sudo debconf-set-selections && sudo echo "slapd slapd/password2 password pass" | sudo debconf-set-selections && sudo echo "slapd slapd/purge_database boolean true" | sudo debconf-set-selections && sudo echo "slapd slapd/move_old_database boolean true" | sudo debconf-set-selections && sudo dpkg-reconfigure -f noninteractive slapd
```

## youtubeの動画
- https://www.youtube.com/watch?v=LKSWE_endX8&list=PL_RwLDGrI9OukEWiXyLWKxy-ccuBReL-o
### 1
### 2
### 3
- [3](https://www.youtube.com/watch?v=ZFym0_qacz0&t=452s)
- 目次
    - apacheのインストール
    - Apacheのconfの配置
    - トップページの配置
    - Apacheサービスの有効化

### 4
### 5
### 6
### 7
### 8

## p64, p65
- playbookを使わない方法
```sh
# ユーザ作成
a -i inv.ini compute_nodes -b -K -m user -a \
    'user=user01 groups="sudo" append=yes comment="test user"'
a -i inv.ini compute_nodes -bK -m user -a 'user=user01 state=absent'
# ファイル作成
a -i inv.ini compute_nodes -m file -a 'path=$HOME/test.txt state=touch'
# ファイル削除
a -i inv.ini compute_nodes -m file -a 'path=$HOME/test.txt state=absent'
```

## p65
- playbookを使う方法
```sh
a -i inv.ini 
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