include:
  - logstash.logstash

extend:
  logstash:
    file.managed:
      - name: /etc/logstash/conf.d/webinterface.conf
      - source: salt://logstash/logstash_webinterface.conf.jinja
      - user: root
      - group: adm
      - mode: 640
      - template: jinja
      - require:
        - pkg: logstash
