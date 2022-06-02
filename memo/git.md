# gitについて

## 2つのマシンで作業する
研究室のマシンとopt02で論文を書く時のgit運用  
mergeとpullを使って連携する
```sh
# 研究室のマシンで論文ファイルを編集後
git add .
git commit -m "***"
git push origin saito

# opt02
# リモートレポジトリから，リモート追跡ブランチへ
git fetch origin saito
# リモート追跡ブランチの存在を確認
git branch -a
# リモート追跡ブランチのコミットの確認
git log remotes/origin/saito
# リモート追跡ブランチから，作業ブランチへマージ
git merge remotes/origin/saito
# mergeの直前に戻す(コンフリクトが発生した時など)
git merge --abort
```

コミットの取り消し
```sh
# 直前のコミットの取り消し (ローカル)
git reset --soft HEAD^
```

強制PUSH
```sh
git push origin +saito
```

過去のコミットへ戻す
```sh
# commitIDの確認
git log origin/saito
# --hardはワーキングツリーもそもcommiitIDの状態にするオプション
git reset --hard <commitID>
```

一時的にコミットへ移動する
```sh
# VALinuxの最初に戻る
# 以下どのコマンドでもOK
git checkout v1.0
git checkout origin/master
git checkout master
# 現在に戻る
git checkout saito
# 強制
git checkout --force
```

ブランチの作成
```git
git branch <branch name>
git checkout <branch name>
git push origin <branch name>
```

git init するときにmasterになるので，デフォルトブランチをmainに変更する[[参考](https://parashuto.com/rriver/tools/change-git-default-branch-name)]
```sh
git config --global init.defaultBranch main
# init時に毎回ブランチ名を指定する (2.28から)
git init --initial-branch main
# 既存のリポジトリのブランチ名を変える
## その前にcommit する必要あり
git branch --move master main
```