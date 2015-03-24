# ELK

ElasticSearch, Logstash, Kibana and Lumberjack (Logstash-Forwarder)

### To run Lumberjack

```bash
$ make
```

### To run ELK

```bash
$ make elk
```

### To access Kibana

Make sure you have the latest [~/.ssh/config](https://github.paypal.com/DT-CCSP/ssh-config.d)
```
$ ssh kibana -fNC
$ open http://localhost:9292/
```

### To generate selfsigned certs

```bash
$ cd vendor/log-courier
$ make selfsigned
```
