# kvmのメモ

## k8sクラスタ用のVM(0406~)
**imp10**
```sh
sudo virt-install \
    --name node100 \
    --os-variant ubuntu20.04 \
    --vcpus 4 \
    --ram 8192 \
    --location http://ftp.ubuntu.com/ubuntu/dists/focal/main/installer-amd64/ \
    --network bridge=virbr0,model=virtio \
    --graphics none \
    --extra-args='console=ttyS0,115200n8 serial'

hostname: node-100
ip: 192.168.122.100
```
```sh
sudo virt-install \
    --name node101 \
    --os-variant ubuntu20.04 \
    --vcpus 4 \
    --ram 8192 \
    --location http://ftp.ubuntu.com/ubuntu/dists/focal/main/installer-amd64/ \
    --network bridge=virbr0,model=virtio \
    --graphics none \
    --extra-args='console=ttyS0,115200n8 serial'

hostname: node-101
ip: 192.168.122.101
```

**imp09**
```sh
sudo virt-install \
    --name node090 \
    --os-variant ubuntu20.04 \
    --vcpus 4 \
    --ram 8192 \
    --location http://ftp.ubuntu.com/ubuntu/dists/focal/main/installer-amd64/ \
    --network bridge=virbr0,model=virtio \
    --graphics none \
    --extra-args='console=ttyS0,115200n8 serial'

hostname: node-090
ip: 192.168.122.90
```
```sh
sudo virt-install \
    --name node091 \
    --os-variant ubuntu20.04 \
    --vcpus 4 \
    --ram 8192 \
    --location http://ftp.ubuntu.com/ubuntu/dists/focal/main/installer-amd64/ \
    --network bridge=virbr0,model=virtio \
    --graphics none \
    --extra-args='console=ttyS0,115200n8 serial'

hostname: node-091
ip: 192.168.122.91
```


## 
```sh
sudo virt-install \
    --name node-10 \
    --os-variant ubuntu20.04 \
    --vcpus 8 \
    --ram 32768 \
    --location http://ftp.ubuntu.com/ubuntu/dists/focal/main/installer-amd64/ \
    --network bridge=virbr0,model=virtio \
    --graphics none \
    --extra-args='console=ttyS0,115200n8 serial'

hostname: node-10
ip: 192.168.122.10
```

```sh
sudo virt-install \
    --name node-09 \
    --os-variant ubuntu20.04 \
    --vcpus 8 \
    --ram 32768 \
    --location http://ftp.ubuntu.com/ubuntu/dists/focal/main/installer-amd64/ \
    --network bridge=virbr0,model=virtio \
    --graphics none \
    --extra-args='console=ttyS0,115200n8 serial'

hostname: node-09
ip: 192.168.122.9
```
