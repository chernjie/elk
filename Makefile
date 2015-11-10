LOGSTASH_IP=$LOGSTASH_IP

run:
	service logstash restart && \
	service nginx restart

master:
	hostname | xargs echo node.name: >> /etc/elasticsearch/elasticsearch.yml

slave:
	hostname | xargs echo node.name: >> /etc/elasticsearch/elasticsearch.yml
	echo node.master: false >> /etc/elasticsearch/elasticsearch.yml

test:
	bin/runtest.sh

build: build_logcourier build_forwarder

build_logcourier:
	cd vendor/log-courier && make

build_forwarder:
	cd vendor/logstash-forwarder \
	&& make \
	&& PREFIX=/opt/logstash-forwarder make generate-init-script

logstash-forwarder:
	service logstash-forwarder restart
	sleep 2

install-logstash-forwarder:
	mkdir -p /var/log/logstash-forwarder /var/lib/logstash-forwarder
	ln -sf $(shell pwd)/etc/logstash-forwarder.conf /etc/logstash-forwarder.conf
	ln -sf $(shell pwd)/vendor/logstash-forwarder /opt/logstash-forwarder
	ln -sf $(shell pwd)/etc/default/logstash-forwarder /etc/default
	ln -sf $(shell pwd)/etc/init.d/logstash-forwarder /etc/init.d
	ln -sf $(shell pwd)/etc/logrotate.d/logstash-forwarder /etc/logrotate.d
	ln -sf $(shell pwd)/etc /var/lib/logstash-forwarder

courier:
	bin/log-courier -config etc/logstash-forwarder.conf

install: install_aptkey install_logstash install_elasticsearch install_nginx install_configuration install_kibana install_elasticsearch_plugin

install_aptkey:
	apt-key adv --keyserver pool.sks-keyservers.net --recv-keys 46095ACC8548582C1A2699A9D27D666CD88E42B4

LOGSTASH_MAJOR=2.0
install_logstash:
	echo "deb http://packages.elasticsearch.org/logstash/${LOGSTASH_MAJOR}/debian stable main" > /etc/apt/sources.list.d/logstash.list
	apt-get update
	apt-get install -y --no-install-recommends logstash

ELASTICSEARCH_MAJOR=2.0
install_elasticsearch:
	echo "deb http://packages.elasticsearch.org/elasticsearch/${ELASTICSEARCH_MAJOR}/debian stable main" > /etc/apt/sources.list.d/elasticsearch.list
	apt-get update
	apt-get install -y elasticsearch

install_elasticsearch_plugin:
	service elasticsearch start
	/usr/share/elasticsearch/bin/plugin -install elasticsearch/kibana3/latest
	/usr/share/elasticsearch/bin/plugin -install elasticsearch/marvel/latest
	# /usr/share/elasticsearch/bin/plugin -install royrusso/elasticsearch-HQ
	# /usr/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head
	# /usr/share/elasticsearch/bin/plugin -install lukas-vlcek/bigdesk

install_nginx:
	apt-get install -y nginx
	rm /etc/nginx/sites-enabled/default

install_kibana:
	rm -rf /usr/share/nginx/html/kibana
	wget http://download.elasticsearch.org/kibana/kibana/kibana-latest.zip -O /var/tmp/kibana.zip
	apt-get install -y unzip
	unzip /var/tmp/kibana.zip -d /usr/share/nginx/html
	mv /usr/share/nginx/html/kibana-latest /usr/share/nginx/html/kibana
	cp etc/nginx/html/config.js /usr/share/nginx/html/kibana/config.js

install_configuration:
	rm -rf /etc/nginx/conf.d /etc/logstash/conf.d /usr/share/nginx/html
	ln -sf $(shell pwd)/etc/nginx/conf.d /etc/nginx
	ln -sf $(shell pwd)/etc/nginx/conf.d /etc/nginx
	ln -sf $(shell pwd)/etc/nginx/html /usr/share/nginx
	ln -sf $(shell pwd)/etc/logstash /etc/logstash/conf.d
	ln -sf $(shell pwd)/etc/ssl /etc/logstash/ssl
	ln -sf conf.d/patterns.d /etc/logstash
	ln -sf $(shell pwd)/etc/elasticsearch/config/elasticsearch.yml /etc/elasticsearch/
	ln -sf $(shell pwd)/etc/default/elasticsearch /etc/default/elasticsearch
	echo 127.0.0.1 logstash.local elasticsearch.local kibana.local >> /etc/hosts

