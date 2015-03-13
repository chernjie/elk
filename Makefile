all: install

install: install_logstash install_elasticsearch install_logcourier install_forwarder etchosts

install_logstash:
	brew install logstash

install_elasticsearch:
	brew install elasticsearch

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
	logstash agent -f etc/logstash/logstash.conf

run: elasticsearch logstash

test:
	run
