#!pydsl

shipper_conf = '/etc/logstash/conf.d/shipper.conf.jinja'

shipper_defaults = {
    'log4j_port': 4712,
}

broker_host = None
for k, v in __salt__['publish.publish']('*', 'grains.item', 'roles', 'glob', TIMEOUT).iteritems():
    if 'logstash.broker' in v.get('roles', []):
        broker_host = k

include('logstash.logstash')

extend('logstash')\
    .file.managed(
        'name'=shipper_conf,
        'source'='salt://logstash/files{}'.format(shipper_conf),
        'user'='root',
        'group'='adm',
        'mode'='0644',
        'template'='jinja',
        'default'=shipper_defaults,
        'broker_host'=broker_host)\
    .require('pkg': 'logstash')
