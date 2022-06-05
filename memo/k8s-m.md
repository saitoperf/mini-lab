# kubeadm
- official site : https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/
- k8sクラスタをデプロイするツール

## 共通設定
```sh
swapoff -a

# install kubeadm
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system

sudo apt install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
```

## k8sマスターの構築
```sh
# マスタ
sudo apt install -y kubelet kubeadm kubectl
mkdir ~/kubeadm
touch ~/kubeadm/kubeadm-config.yaml
vim ~/kubeadm/kubeadm-config.yaml
```
```yaml
# kubeadm-config.yaml
# cgroupDriverとpodネットワークの設定
kind: ClusterConfiguration
apiVersion: kubeadm.k8s.io/v1beta3
kubernetesVersion: v1.24.1
networking:
  podSubnet: "172.24.0.0/16" # --pod-network-cidr(10.244.0.0/16はダメ)
---
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
cgroupDriver: cgroupfs
```
```sh
# マスタ: コントロールプレーンの作成
sudo kubeadm init --config ~/kubeadm/kubeadm-config.yaml
```
```sh
# マスタ: コントロールプレーンでコンテキストを設定する
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# マスタ: nodeの確認
# kubectl get nodes
```
```sh
# マスタ: weaveのインストール: https://www.weave.works/docs/net/latest/kubernetes/kube-addon/
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
```

## クラスタの削除(Clean up)
- Clean up: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#tear-down
```sh
# nodeの停止
k drain node-101 --delete-emptydir-data --force --ignore-daemonsets
k drain node-100 --delete-emptydir-data --force --ignore-daemonsets
# 確認
k get no
# マスタ:
sudo kubeadm reset
sudo systemctl restart docker
# ワーカ:
sudo kubeadm reset
sudo systemctl restart docker

# マスタ: その他の後処理
sudo rm -rf /etc/cni/net.d && rm ~/.kube/config
```

## トークンの確認と再生成
```sh
kubeadm token create --print-join-command
kubeadm token list

# トークンのみ
kubeadm token list | awk 'NR==2 {print $1}'
# --discovery-token-ca-cert-hashのみ
# https://zaki-hmkc.hatenablog.com/entry/2020/04/05/103651
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'
```

## memo 
```sh
# これでアプリのデプロイができるようになった!
# マスタ: 確認
git clone https://github.com/MasayaAoyama/kubernetes-perfect-guide.git
cd ~/kubernetes-perfect-guide/samples/chapter05/ &&
k apply -f sample-deployment.yaml
k get deploy -o wide
k get po -o wide
k exec -it sample-deployment-***-*** /bin/bash
# マスタ: 削除
k delete -f sample-deployment.yaml 
```
```sh
sudo kubeadm init --config ~/kubeadm/kubeadm-config.yaml
# 上記のコマンドが長い場合
kubeadm config images pull
```
kubeadm join 192.168.122.12:6443 --token 30vi9l.iu7bna26azxv64z9 \
  --discovery-token-ca-cert-hash sha256:80ea56ac5fe063e1afabca56ba55d18c08b76c637c884ee279486a4382760b4f