# Ansible

- Run with `ansible-playbook --vault-id pass@prompt --vault-id inventory@prompt deploy-app.yml`
- Run with `ansible-playbook -K plays.yml` -----  `-K` = `--ask-become-pass`

Or if want to run specific part only, then use tags
- run nginx part only - `ansible-playbook -K plays.yml --tags "nginx"`
- run initial part only (without configuring user environment) - `ansible-playbook -K plays.yml --tags "initial"`

`--tags [tag1, tag2]` - run only tasks with the tags tag1 and tag2
`--skip-tags [tag3, tag4]` - run all tasks except those with the tags tag3 and tag4

## How to create password with Vault

```shell
ansible-vault encrypt_string --ask-vault-pass --name 'main_user_password' '123'
```

## How to create password for nginx

```shell
sudo sh -c "echo -n 'sammy:' >> /etc/nginx/.htpasswd"

sudo sh -c "openssl passwd -apr1 >> /etc/nginx/.htpasswd"
```

modify file `/etc/nginx/sites-available/default`
```nginx
location / {
    # proxy_pass http://127.0.0.1:8080;
    auth_basic "Restricted Content";
    auth_basic_user_file /etc/nginx/.htpasswd;
}
```

restart nginx `sudo service nginx restart`
