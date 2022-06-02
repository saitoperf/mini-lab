# KVMゲストのセットアップ
[ubuntuの公式ブログ](https://ubuntu.com/blog/kvm-hyphervisor)  
ファイアウォールの設定はfirecracker_setup.mdを参照。

## 1 KVMゲストの立ち上げ
### OSのインストール
関連パッケージのインストール
```
sudo apt -y install \
    bridge-utils \
    cpu-checker \
    libvirt-clients \
    libvirt-daemon \
    virt-manager \
    qemu \
    qemu-kvm \
    curl
```

sudo apt -y install 
    bridge-utils 
    cpu-checker 
    libvirt-clients 
    libvirt-daemon 
    qemu 
    qemu-kvm

ゲストOSのインストール
```
sudo virt-install \
    --name ubuntu \
    --os-variant ubuntu20.04 \
    --vcpus 2 \
    --ram 2048 \
    --location http://ftp.ubuntu.com/ubuntu/dists/focal/main/installer-amd64/ \
    --network bridge=virbr0,model=virtio \
    --graphics none \
    --extra-args='console=ttyS0,115200n8 serial'
```

### OSの起動
ホスト：ゲストOSの起動
```
virsh start vm-name
virsh list --all
```

ホスト：ゲストIPアドレスの確認
```
virsh net-dhcp-leases default
```

ホスト：SSHでゲストに接続
```
ssh username@192.168.122.xx/24
```

ゲスト：ゲストにコンソール接続出来るようにする
```
sudo systemctl start serial-getty@ttyS0 &&
sudo systemctl enable serial-getty@ttyS0
```

必要パッケージ
```
sudo apt update
sudo apt install -y net-tools nmap curl git
```

ホスト：ゲストへのコンソールアクセス
```
virsh console vm-name
```

## 2 ネットワーク設定
### インターネットとの疎通
ホスト：tapの作成
```sh
sudo ip addr flush vnet1 && sudo ip link del vnet1 && 
sudo ip tuntap add vnet1 mode tap && sudo ip link set vnet1 up &&
sudo ip addr add 172.16.0.1/24 dev vnet1
```

ホスト：ファイアウォールの設定
```sh
sudo iptables-restore < ~/backup/iptables.rules.v1 &&
sudo iptables --policy FORWARD ACCEPT --table filter &&
sudo iptables -t nat -A POSTROUTING -o eno1 -j MASQUERADE &&
sudo iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT &&
sudo iptables -A FORWARD -i vnet1 -o eno1 -j ACCEPT
# sshが切れるので，console接続する
virsh console ubuntu5
```

ゲスト：
```
sudo ip addr flush enp1s0 &&
sudo ip addr add 172.16.0.10/24 dev enp1s0 &&
sudo ip link set enp1s0 up &&
sudo ip route add default via 172.16.0.1 dev enp1s0 &&
sudo sh -c "echo nameserver 8.8.8.8 > /etc/resolv.conf"
```


### 同一セグメント内での疎通
必要パッケージのインストール
```
sudo apt install -y net-tools iperf3 vim curl nmap
```

ゲスト：インターフェースとデフォルトルート(br0:192.168.3.1)の設定
```
sudo ip addr flush enp1s0 &&
sudo ip addr add 192.168.3.20/24 dev enp1s0 &&
sudo ip link set enp1s0 up &&
sudo ip route add default via 192.168.3.1 dev enp1ifconfis0
```

ホスト：TAPデバイス(vnet1)とブリッジを接続
```
sudo ip link add name br0 type bridge
sudo ip link set br0 up &&
sudo ip addr add 192.168.3.1/24 dev br0 &&
sudo ip addr flush vnet1 &&
sudo ip link set vnet1 up &&
sudo ip link set dev vnet1 master br0 &&
sudo ip link set dev enp2s0f0 master br0
```

ゲスト：疎通確認
```
ping 192.168.3.3 -I 192.168.3.20
```

imp09：疎通確認
```
ping 192.168.3.20 -I 192.168.3.3
```

## 3 トラブルシューティング

## virshの使い方
- [参考](https://qiita.com/hana_shin/items/3fc67e2e6132bd534932)
- 仮想マシンとハイパーバイザのリソースを管理するコマンド

### 各種情報の表示
仮想マシン一覧  
- virsh list

仮想マシンのID
- virsh domid ubuntu-guest

仮想マシンの情報  
- virsh dominfo ubuntu-guest

UUIDの表示
- virsh domuuid ubuntu-guest
- UUID：インターネット上のオブジェクトを識別するための128bitの文字列を指し，世界中で唯一のID

### 起動・停止など
起動
- virsh start ubuntu-guest
- virsh start ubuntu-guest --console
    - 起動とコンソール接続

停止
```
$ virsh shutdown ubuntu-guest
$ virsh list --all
 Id   Name           State
-------------------------------
 4    ubuntu-kvm     running
 -    ubuntu-guest   shut off
```

一時停止
- virsh suspent ubuntu-guest

再開
- virsh resume ubuntu-guest

強制終了
- virsh destroy ubuntu-guest

削除
- virsh undefine ubuntu-guest

接続
- virsh console ubuntu-guest

## バックアップ
[参考](https://mseeeen.msen.jp/backup-and-restore-virtual-image-for-kvm/)
バックアップ
```
virsh shutdown ubuntu
virsh dumpxml ubuntu > ./kvm_backup/ubuntu.xml
sudo cp -p /var/lib/libvirt/images/ubuntu.qcow2 kvm_backup/
```

リストア
```

```

## 複製
[参考](http://ossfan.net/setup/kvm-09.html)
```
virsh shutdown ubuntu
sudo virt-clone --original ubuntu --name ubuntu-clone --file ~/kvm_backup/ubuntu-clone.qcow2
```

## スナップショット
[参考](https://qiita.com/hana_shin/items/c43f824f16797e0d7e62)
```sh
# 作成
virsh snapshot-create-as --domain ubuntu --name init
# 確認
virsh snapshot-list --domain ubuntu
# 復元
virsh snapshot-revert --domain ubuntu --snapshotname init
```

## vCPUとメモリの変更
[参考](https://www.eastforest.jp/centos6/3694)
```sh
# メモリの変更
virsh setmaxmem node091 8G
virsh setmem node091 8G --config
# vCPU数の変更
virsh setvcpus node101 4 --config --maximum &&
virsh setvcpus node101 4 --config
# 確認
virsh dumpxml node090 | grep vcpu
virsh dominfo node090
# 時々刻々と変わっている
virsh vcpuinfo node090
```

[vCPUに物理コアを指定する](https://enakai00.hatenablog.com/entry/2015/05/11/101429)
```sh
# node-090
virsh vcpupin node090 0 0 && virsh vcpupin node090 1 1 && virsh vcpupin node090 2 2 && virsh vcpupin node090 3 3 &&
virsh vcpuinfo node090
# node-091
virsh vcpupin node091 0 4 && virsh vcpupin node091 1 5 && virsh vcpupin node091 2 6 && virsh vcpupin node091 3 7 &&
virsh vcpuinfo node091
# node-100
virsh vcpupin node100 0 0 && virsh vcpupin node100 1 1 && virsh vcpupin node100 2 2 && virsh vcpupin node100 3 3 &&
virsh vcpuinfo node100
# node-101
virsh vcpupin node101 0 4 && virsh vcpupin node101 1 5 && virsh vcpupin node101 2 6 && virsh vcpupin node101 3 7 &&
virsh vcpuinfo node101
```
```sh
# node-09
virsh vcpupin node-09 0 0 && 
virsh vcpupin node-09 1 1 && 
virsh vcpupin node-09 2 2 && 
virsh vcpupin node-09 3 3 &&
virsh vcpupin node-09 4 4 &&
virsh vcpupin node-09 5 5 &&
virsh vcpupin node-09 6 6 &&
virsh vcpupin node-09 7 7 &&
virsh vcpuinfo node-09
# node-10
virsh vcpupin node-10 0 0 && 
virsh vcpupin node-10 1 1 && 
virsh vcpupin node-10 2 2 && 
virsh vcpupin node-10 3 3 &&
virsh vcpupin node-10 4 4 &&
virsh vcpupin node-10 5 5 &&
virsh vcpupin node-10 6 6 &&
virsh vcpupin node-10 7 7 &&
virsh vcpuinfo node-10
```


## ディスクの拡張
ディスク容量を10GiB拡張します
[参考文献](https://blog.adachin.me/archives/2023)
```sh
# ホスト：ゲストのシャットダウン
sudo virsh shutdown
# ホスト：ディスク容量の確認
sudo qemu-img info /var/lib/libvirt/images/vm01.qcow2
# ホスト：スナップショットがある場合は削除
sudo virsh snapshot-delete --domain vm01 --snapshotname <snapshot名>
# ホスト：VMに割り当てている領域を拡張
sudo qemu-img resize  /var/lib/libvirt/images/vm01.qcow2 +10G
# ゲスト：lsblkコマンドでVMが認識しているブロックデバイスのサイズが拡張されていることを確認
lsblk
# ゲスト：パーティションを拡張
fdisk /dev/vda
# つづき
```
