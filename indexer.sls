include:
  - logstash.logstash

{% set indexer_conf = '/etc/logstash/conf.d/indexer.conf' %}
extend:
  logstash:
    file.managed:
      - name: {{ indexer_conf }}
      - source: {{ 'salt://logstash/files{}'.format(indexer_conf) }}
      - user: root
      - group: adm
      - mode: 644
      - template: jinja
      - require:
        - pkg: logstash
