# kubeadm
- official site : https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/
- k8sクラスタをデプロイするツール

## 共通設定
- [k8s-m.mdを参照](./k8s-m.md#共通設定)

## k8sワーカーの構築
```sh
# ワーカ: クラスタにjoinする
sudo apt install -y kubelet kubeadm
sudo kubeadm join 192.168.122.12:6443 --token *** --discovery-token-ca-cert-hash sha256:***
```

## クラスタの削除(Clean up)
- Clean up: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#tear-down
```sh
# ワーカ:
sudo kubeadm reset
sudo systemctl restart docker
```
