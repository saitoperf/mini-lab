# iptables 

## コマンド
- 削除
```sh
# filterテーブルの，FORWARDチェインの，ルール56を削除
sudo iptables -t filter -D FORWARD 56
sudo iptables -t filter -D FORWARD 57
```

- 追加
```sh
```

- 表示
```sh
# Filter テーブル
sudo iptables --list --line-numbers
# nat テーブル
sudo iptables -t nat --list --line-numbers
```

- チェイン内のデフォルトポリシーの変更
```sh
sudo iptables -t filter --policy FORWARD ACCEPT
```