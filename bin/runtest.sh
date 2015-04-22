#!/usr/bin/env bash

require () {
  for i
  do
    if ! command -v $i > /dev/null
    then
      echo command $i does not exist, please install
      exit 1
    fi
  done
}

ifErrorExit () {
  local errcode=$1
  shift
  test $errcode -eq 0 && echo -n . && return 0
  echo $@ >&2
  exit $errcode
}

assertValidJson () {
  json -nf $@
  ifErrorExit $? "Invalid json $@"
}

assertValidLogstashConfig () {
  logstash --config etc/logstash --configtest > /dev/null
  ifErrorExit $? "Invalid logstash configuration"
}

assertValidYaml () {
  js-yaml -t $@ > /dev/null
  ifErrorExit $? "Invalid yaml $@"
}

main () {
  assertValidJson etc/logstash-forwarder/config.json
  assertValidLogstashConfig
  git ls-files | grep -e yml -e yaml | while read i
  do
    assertValidYaml $i
  done
  echo done
}

require json logstash git js-yaml
case $1 in
  *) main;;
esac