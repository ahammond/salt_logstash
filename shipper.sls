include:
  - logstash.logstash

{% set shipper_conf = '/etc/logstash/conf.d/shipper.conf' %}
extend:
  logstash:
    file.managed:
      - name: {{ shipper_conf }}
      - source: {{ 'salt://logstash/files{}'.format(shipper_conf) }}
      - group: adm
      - template: jinja
      - default:
        zeromq_port: 2120   {# note this is the port zeromq clients should forward to #}
        log4j_port: 4712    {# note this is the port log4j SocketAppenders should forward to #}
        syslog_port: 5544   {# note this is the port rsyslog clients should forward to #}
      - broker_host: {{ salt['publish.publish']('role:logstash.broker', 'grains.item', 'id', 'grain').keys().pop() }}
      - require:
        - pkg: logstash
