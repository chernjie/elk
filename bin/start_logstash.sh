#!/usr/bin/env bash

exec /opt/logstash/bin/logstash web &
exec /opt/logstash/bin/logstash agent --config /etc/logstash --log /var/log/logstash.log
