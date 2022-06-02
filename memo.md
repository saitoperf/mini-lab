# memo 
```sh
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

```sh
# node090
sudo virt-install \
    --name node090 \
    --os-variant ubuntu20.04 \
    --vcpus 4 \
    --ram 8192 \
    --disk size=50 \
    --location http://ftp.ubuntu.com/ubuntu/dists/focal/main/installer-amd64/ \
    --network bridge=virbr0,model=virtio \
    --graphics none \
    --extra-args='console=ttyS0,115200n8 serial'
# node091
sudo virt-install \
    --name node091 \
    --os-variant ubuntu20.04 \
    --vcpus 4 \
    --ram 8192 \
    --disk size=50 \
    --location http://ftp.ubuntu.com/ubuntu/dists/focal/main/installer-amd64/ \
    --network bridge=virbr0,model=virtio \
    --graphics none \
    --extra-args='console=ttyS0,115200n8 serial'
```