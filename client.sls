rsyslog:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/rsyslog.d/*
      - file: /etc/hosts

  file.managed:
    - name: /etc/rsyslog.d/00-logstash.conf
    - source: salt://logstash/files/etc/rsyslog.d/00-logstash.conf.jinja
    - user: root
    - group: root
    - mode: 644
    - template: jinja
