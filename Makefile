all: install

run: elk install

install:
	docker-compose up -d

elk:
	docker-compose up -d --file docker-compose-elk.yml

build: install_logcourier install_forwarder etchosts

install_logcourier:
	cd vendor/log-courier && make

install_forwarder:
	cd vendor/logstash-forwarder && make

etchosts:
	echo Make sure you have the following DNS set in your etc/hosts
	cat etc/hosts

lumberjack:
	bin/logstash-forwarder -config etc/logstash-forwarder

courier:
	bin/log-courier -config etc/logstash-forwarder/config.json

