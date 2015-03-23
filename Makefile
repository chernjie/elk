all: lumberjack_docker

run: elk lumberjack_docker

lumberjack_docker:
	# docker-compose does not support --add-hosts yet, so run it manually
	# https://github.com/docker/compose/pull/848
	# docker-compose up -d
	docker run -dit --name logstashforwarder \
		-v ./etc/ssl:/etc/ssl \
		-v ./etc/logstash-forwarder:/etc/logstash-forwarder \
		-v /var/log:/var/log \
		--add-hosts logstash.local:${LOGSTASH_IP:-127.0.0.1}
		willdurand/logstash-forwarder

elk:
	docker-compose up -d --file docker-compose-elk.yml

build: build_logcourier build_forwarder etchosts

build_logcourier:
	cd vendor/log-courier && make

build_forwarder:
	cd vendor/logstash-forwarder && make

etchosts:
	echo Make sure you have the following DNS set in your etc/hosts
	cat etc/hosts

lumberjack:
	bin/logstash-forwarder -config etc/logstash-forwarder

courier:
	bin/log-courier -config etc/logstash-forwarder/config.json

