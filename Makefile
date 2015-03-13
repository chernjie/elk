all: install

install: install_logstash install_elasticsearch install_logcourier install_forwarder etchosts

install_logstash:
	brew install logstash

install_elasticsearch:
	brew install elasticsearch
	cat etc/elasticsearch/elasticsearch.yml >> /usr/local/etc/elasticsearch/elasticsearch.yml

install_logcourier:
	cd vendor/log-courier && make

install_forwarder:
	cd vendor/logstash-forwarder && make

etchosts:
	echo Make sure you have the following DNS set in your etc/hosts
	cat etc/hosts

elasticsearch:
	test -f ~/Library/LaunchAgents/homebrew.mxcl.elasticsearch.plist || ln -sfv /usr/local/opt/elasticsearch/*.plist ~/Library/LaunchAgents
	launchctl load ~/Library/LaunchAgents/homebrew.mxcl.elasticsearch.plist

logstash:
	logstash agent -f etc/logstash/logstash.conf &

kibana:
	logstash web & open "http://kibana.local:9292/index.html#/dashboard/file/logstash.json"

run: elasticsearch logstash kibana

test:
	run
