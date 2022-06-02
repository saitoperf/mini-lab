# LDAP
- [概念を分かりやすく説明している](https://milestone-of-se.nesuke.com/l7protocol/ldap/ldap-summary/)
- [..](http://www.osssme.com/doc/funto92.html)

## インストール
- [ubuntu公式](https://ubuntu.com/server/docs/service-ldap)
```sh
sudo apt install slapd ldap-utils
sudo dpkg-reconfigure slapd
```

```sh
# ルート管理者は admin
ldapsearch -x -LLL -H ldap:/// -b dc=example,dc=com dn
```
### LDAP初期エントリ登録
```sh
ldapadd -x -D cn=admin,dc=example,dc=com -W -f init.ldif
```
```ldif
# init.ldif
dn: ou=People,dc=example,dc=com
objectClass: organizationalUnit
ou: People

dn: ou=Group,dc=example,dc=com
objectClass: organizationalUnit
ou: Group
```
- 確認
```sh
ldaps -x -LLL -b dc=example,dc=com
```

### グループアカウントのエントリ登録
```sh
ldapadd -x -D cn=admin,dc=example,dc=com -W -f group.ldif
```
```ldif
#  group.ldif
dn: cn=system01,ou=Group,dc=example,dc=com
objectClass: posixGroup
objectClass: top
cn: system01
gidNumber: 1001

dn: cn=system02,ou=Group,dc=example,dc=com
objectClass: posixGroup
objectClass: top
cn: system02
gidNumber: 1002

dn: cn=system03,ou=Group,dc=example,dc=com
objectClass: posixGroup
objectClass: top
cn: system03
gidNumber: 1003
```

### ユーザアカウントのエントリ登録
```sh
ldapadd -x -D cn=admin,dc=example,dc=com -W -f user.ldif
```
```ldif
# user.ldif
dn: uid=user01,ou=People,dc=example,dc=com
uid: user01
cn: Test User 01
objectClass: account
objectClass: posixAccount
objectClass: top
userPassword: user01
loginshell: /bin/bash
uidNumber: 1001
gidNumber: 1001
homeDirectory: /home/user01

dn: uid=user02,ou=People,dc=example,dc=com
...

dn: uid=user03,ou=People,dc=example,dc=com
...
```
- 確認
```sh
# ldap で接続 (ldapsが使えない)
ldapsearch -x -LLL -D cn=admin,dc=example,dc=com -b cn=admin,dc=example,dc=com -W
```

### 修正
**属性の追加**
```sh
ldapmodify -x -D cn=admin,dc=example,dc=com -W -f modify01.ldif 
# 確認
ldapsearch -x -LLL -b dc=example,dc=com -D cn=admin,dc=example,dc=com -W "(uid=user02)"
```
```
# modify01.ldif
dn: uid=user02,ou=People,dc=example,dc=com
changetype: modify
add: gecos
gecos: Test User 02
-
add: description
description: Test Description
-
```
**属性の削除**
```sh
ldapmodify -x -D cn=admin,dc=example,dc=com -W -f modify02.ldif
# 確認
ldapsearch -x -D cn=admin,dc=example,dc=com -b dc=example,dc=com -W
```
```
# modify01.ldif
dn: uid=user02,ou=People,dc=example,dc=com
changetype: modify
delete: description
-
```

**属性の修正**
```sh
# 同じ手順
ldapmodify -x -D cn=admin,dc=example,dc=com -W -f modify02.ldif
```
```sh
# modify03.ldif
...
replate: gecos
gecos: Sample User 02
...
```


### その他コマンド
```sh
# 属性確認
ldapsearch -x -LLL -D cn=admin,dc=example,dc=com -W -b dc=example,dc=com
```

### ポート開放
- 出来ない問題
- 後で解決する
- というか firewall-cmd で解放出来ない問題
```sh
sudo firewall-cmd --add-service=ldap
sudo firewall-cmd --add-service=ldaps
# 確認
sudo firewall-cmd --list-all
```
sudo firewall-cmd --zone=trusted --add-port=636/tcp --permanent
sudo firewall-cmd --zone=trusted --add-service=ldap --permanent


### TLS対応
- https://ubuntu.com/server/docs/service-ldap-with-tls
- このドキュメントの通りにすればOK
- `ldapwhoami -x -H ldaps://ldap01.example.com`は636ポートが空いていないため不可
- `ldapwhoami -x -ZZ -H ldap://ldap01.example.com `はOK