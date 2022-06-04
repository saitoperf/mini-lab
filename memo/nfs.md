# NFSシステムの構築
- [ubuntu](https://ubuntu.com/server/docs/service-nfs)

## サーバ
```sh
sudo apt install -y nfs-kernel-server
sudo systemctl start nfs-kernel-server.service
# firewall off (本当はoffにしたくない)
sudo systemctl stop firewalld
# 設定ファイル
sudo vim /etc/exports
```
```sh
/home    192.168.2.0/255.255.255.0(rw,sync,no_subtree_check)
```
```sh
# 設定ファイルの内容と適用
sudo exportfs -a
```

## クライアント
```sh
sudo apt install -y nfs-common
# マウント
sudo mount ldap01.example.com:/srv /opt/example
# アンマウント (/home 以外のディレクトリでコマンドを打つ)
sudo umount /home
```

## コマンド
```sh
sudo showmount -a
sudo showmount -e
sudo showmount -d
```

busy
```sh
sudo umount -l /home
sudo fuser -k /home
```