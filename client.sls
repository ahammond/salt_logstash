#!pydsl

import random

state('rsyslog')\
    .service.running(
        enable=True,
        reload=True)\
    .watch(file='/etc/rsyslog.d/*')

config = '/etc/rsyslog.d/00-logstash.conf'
if __grains__.get('log_to_logstash', False):  # By default, not to Logstash
    shipper_hosts = __salt__['publish.publish']('role:logstash.shipper', 'grains.item', 'id', 'grain').keys()
    shipper_host = random.choice(shipper_hosts)
    state(config)\
        .file.managed(
            source='salt://logstash/files{}'.format(config),
            user='root',
            group='root',
            mode='644',
            template='jinja',
            shipper_host=shipper_host)
else:
    state(config).file.absent()

log_to_disk_config = '/etc/rsyslog.d/50-default.conf'
if __grains__.get('log_to_disk', True):         # By default, log to disk.
    state(log_to_disk_config).file.managed(
            source='salt://logstash/files{}'.format(log_to_disk_config))
else:
    state(log_to_disk_config).file.absent()
