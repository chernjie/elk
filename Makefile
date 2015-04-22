LOGSTASH_IP=$LOGSTASH_IP

all: lumberjack_docker

run: elk lumberjack_docker

test:
	bin/runtest.sh

lumberjack_docker:
	# docker-compose does not support --add-host yet, so run it manually
	# https://github.com/docker/compose/pull/848
	# docker-compose up -d
	docker run -dit --name logstashforwarder \
		-v $(pwd)/etc/ssl:/etc/ssl \
		-v $(pwd)/etc/logstash-forwarder:/etc/logstash-forwarder \
		-v /var/log:/var/log \
		--add-host=logstash.local:${LOGSTASH_IP} \
		willdurand/logstash-forwarder

elk:
	docker-compose --file docker-compose-elk.yml up -d

build: build_logcourier build_forwarder etchosts

build_logcourier:
	cd vendor/log-courier && make

build_forwarder:
	cd vendor/logstash-forwarder && make

etchosts:
	echo Make sure you have the following DNS set in your etc/hosts
	cat etc/hosts

lumberjack:
	nohup bin/logstash-forwarder -config etc/logstash-forwarder &

courier:
	bin/log-courier -config etc/logstash-forwarder/config.json

