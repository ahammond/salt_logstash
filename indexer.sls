include:
  - logstash.logtash

extend:
  logstash:
    file.managed:
      - name: /etc/logstash/conf.d/syslog.conf
      - source: salt://logstash/logstash_indexer.conf.jinja
      - user: root
      - group: adm
      - mode: 640
      - template: jinja
      - require:
        - pkg: logstash
