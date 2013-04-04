rsyslog:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/rsyslog.d/*

{% set config = '/etc/rsyslog.d/00-logstash.conf' %}
{{ config }}
  file.managed:
    - source: salt://logstash/files{{ config }}
    - user: root
    - group: root
    - mode: 644
    - template: jinja

/etc/rsyslog.d/50-default.conf
  file.absent
