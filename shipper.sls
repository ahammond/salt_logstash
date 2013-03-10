include:
  - logstash.logstash

extend:
  logstash:
    file.managed:
      - name: /etc/logstash/conf.d/syslog.conf
      - source: salt://logstash/logstash_syslog.conf.jinja
      - user: root
      - group: adm
      - mode: 640
      - template: jinja
      - require:
        - pkg: logstash
