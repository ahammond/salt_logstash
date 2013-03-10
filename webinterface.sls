include:
  - logstash.logstash

extend:
  logstash:
    file.managed:
      - name: /etc/logstash/conf.d/web.conf
      - source: salt://logstash/logstash_web.conf.jinja
      - user: root
      - group: adm
      - mode: 640
      - template: jinja
      - require:
      - pkg: logstash
