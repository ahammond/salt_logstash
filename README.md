# LogStash
========

This state is targeted at people who want to deploy a medium to large-scale
logstash implementation.

A minimal deployment includes one each of the shipper, broker, indexer,
elasticsearch and webinterface boxes.

## pillars

This is still under revision. Currently there's some hacking in place
to support nginx files, but it's not complete or probably correct yet.

```yaml
rsyslog:
  /dev/null:
    - none: None
  {% if 'nginx' == grains.get('role', None) -%}
  /var/log/nginx/access.log:
    - tag: nginx_access
  /var/log/nginx/error.log:
    - tag: nginx_error
  {% endif -%}
```

## states

### logstash.client

You will probably want to add the `logstash.client` state on any boxes that
are using rsyslog. This will send all syslog data to shipper boxes.
Note: this will remove the default rsyslog config file on ubuntu systems.

### logstash.shipper

This is the beginning of the logstash chain proper.
The shipper is currently configured to receive syslog messages (via the
`logstash.client` state), and log4j SocketAppender messages.

### logstash.broker

This depends on having a redis state available to include. We're using
https://github.com/SmartReceipt/salt_redis/

Eventually this will manage access to redis so that only the shipper and
indexer boxes can connect to it.

### logstash.indexer

This pulls messages from the broker and feeds them to elasticsearch.
I don't yet know what the scaling requirements for logstash are, but
I believe we may want to deploy more than one of these.

### logstash.elasticsearch

This should follow the redis pattern, but instead just deploys elasticsearch.
I'm pretty sure we'll want to scale logstash by adding a bunch more es boxes,
but not sure on the details yet.

### logstash.webinterface

This deploys kibana, the bells and whistles web UI for logstash.
TODO: put nginx and google_auth_proxy in front of this to protect access.
