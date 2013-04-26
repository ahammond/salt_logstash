include:
  - logstash.logstash

{% set shipper_conf = '/etc/logstash/conf.d/shipper.conf' %}
extend:
  logstash:
    file.managed:
      - name: {{ shipper_ conf }}
      - source: {{ 'salt://logstash/files{}'.format(shipper_conf) }}
      - group: adm
      - template: jinja
      - default:
        log4j_port: 4712
        syslog_port: 5544   {# note this is the port rsyslog clients should forward to #}
      - broker_host: {{ salt['publish.publish']('role:logstash.broker', 'grains.item', 'id', 'grain') }}
      - require:
        - pkg: logstash
