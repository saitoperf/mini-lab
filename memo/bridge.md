# bridgeの作成
## yamlファイルの記述
```sh
sudo vim /etc/netplan/***.yml
```
```yaml
...
  bridges:
    br0:
      addresses:
      - 192.168.2.1/24
      gateway4: 192.168.2.254
      nameservers:
        addresses:
        - 8.8.8.8
...
```
```sh
sudo netplan apply
```