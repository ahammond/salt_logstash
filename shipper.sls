include:
  - logstash.logstash

{% set shipper_conf = '/etc/logstash/conf.d/shipper.conf' %}
extend:
  logstash:
    file.managed:
      - name: {{ shipper_ conf }}
      - source: {{ 'salt://logstash/files{}'.format(shipper_conf) }}
      - user: root
      - group: adm
      - mode: 644
      - template: jinja
      - default:
        log4j_port: 4712
      - broker_host: ls-broker01
      - require:
        - pkg: logstash
