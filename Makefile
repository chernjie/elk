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
	ps aux | grep etc/logstash/logstash.conf | grep -ve grep | grep -o "[0-9]*" | head -1 | xargs kill -9
	logstash agent -v -f etc/logstash/logstash.conf --log logstash.log &

kibana:
	logstash web & open "http://kibana.local:9292/index.html#/dashboard/file/logstash.json"

run: elasticsearch logstash kibana

test:
	run
