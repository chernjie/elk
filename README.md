# ELK

ElasticSearch, Logstash, Kibana and Lumberjack (Logstash-Forwarder)

### To run Lumberjack (a.k.a. `logstash-forwarder`)

```bash
$ make
```

### To run ELK

Before you run the following command, you may want to make sure that you have completed the security configurations steps below

```bash
$ make elk
```

### To access Kibana

Nginx listens to port 80 so accessing http://servername/ should just work.
Internally, Nginx will first try files from `etc/nginx/html`, and if no files is found, it will fallback to `kibana` container, and the then subsequently `elasticsearch` container.

## Security Configurations (setup)

### To generate selfsigned certs

You have to generate your own selfsigned certs. `log-courier` has prepared a simple tool for that purpose. The same certs and keys will be used for `logstash` and `logstash-forwarder` (a.k.a. `lumberjack`)

```bash
$ cd vendor/log-courier
$ make selfsigned
$ cd -
$ mv vendor/log-courier/selfsigned.crt etc/ssl/certs/selfsigned.crt
$ mv vendor/log-courier/selfsigned.key etc/ssl/private/selfsigned.key
```

### To add user to Nginx basic authentication

```bash
$ htpasswd -b etc/nginx/conf.d/.htpasswd username password
```
