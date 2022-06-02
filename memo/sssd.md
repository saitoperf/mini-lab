# sssd と LDAP の構築
- [ubuntu_blog](https://ubuntu.com/server/docs/service-sssd-ldap)
- [LDAP環境構築](./ldap.md)

## 下準備
`/etc/hosts`と`/etc/ldap/ldap.conf`を修正
```sh
# /etc/hosts
192.168.2.229 ldap01.example.com
# /etc/ldap/ldap.conf
BASE   dc=example,dc=com
URI    ldap://ldap01.example.com
```
- [TSL対応を済ませておく](https://ubuntu.com/server/docs/service-ldap-with-tls)

## LDAPサーバ環境構築
```sh
sudo apt install sssd-ldap ldap-utils
sudo vim /etc/sssd/sssd.conf
```
```sh
[sssd]
config_file_version = 2
domains = example.com

[domain/example.com]
id_provider = ldap
auth_provider = ldap
ldap_uri = ldap://ldap01.example.com
cache_credentials = True
ldap_search_base = dc=example,dc=com
```
```sh
sudo systemctl start sssd
# 自動ディレクトリの作成
sudo pam-auth-update --enable mkhomedir
# userの確認
getent passwd user01
id user01
```


## LDAPクライアン環境構築
```sh
#
sudo apt install sssd-ldap ldap-utils
# 
sudo vim /etc/sssd/sssd.conf
```
```conf
[sssd]
config_file_version = 2
domains = example.com

[domain/example.com]
id_provider = ldap
auth_provider = ldap
ldap_uri = ldap://ldap01.example.com
cache_credentials = True
ldap_search_base = dc=example,dc=com
```
```sh
sudo chmod 600 /etc/sssd/sssd.conf
sudo systemctl start sssd
```


```sh
# imp09 (server)
scp /etc/ssl/certs/ca-certificates.crt tt21saito@192.168.2.230:/home/tt21saito
# imp10 (client)
sudo mv ${HOME}/ca-certificates.crt /etc/ssl/certs/
```