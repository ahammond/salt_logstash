rsyslog
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/rsyslog.d/*

  file.managed:
    - name: /etc/rsyslog.d/00-logstash.conf
    - source: salt://logstash/rsyslog_logstash.conf.jinja
    - user: root
    - group: root
    - mode: 644
    - template: jinja
