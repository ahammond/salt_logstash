include:
  - logstash.logstash

{% set indexer_conf = '/etc/logstash/conf.d/indexer.conf' %}
extend:
  logstash:
    file.managed:
      - name: {{ indexer_conf }}
      - source: {{ 'salt://logstash/files{}'.format(indexer_conf) }}
      - group: adm
      - template: jinja
      - broker_host: {{ salt['publish.publish']('role:logstash.broker', 'grains.item', 'id', 'grain').keys().pop() }}
      - elasticsearch_hosts: {{ salt['publish.publish']('role:logstash.elasticsearch', 'grains.item', 'id', 'grain').keys() }}
      - require:
        - pkg: logstash
