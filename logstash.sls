
{% set logstash_deb_url = 'http://logstash.objects.dreamhost.com/pkg/ubuntu/logstash_1.1.12-1-ubuntu_all.deb' %}
{% set jre = 'openjdk-7-jre' %}

{{ jre }}:
  pkg.installed

{% set logstash_log_dir = '/var/log/logstash' %}
{{ logstash_log_dir }}:
  file.directory:
    - group: adm
    - mode: '2750'

logstash:
  pkg.installed:
    - sources:
      - logstash: {{ logstash_deb_url }}
    - require:
      - pkg: {{ jre }}
  user.present:
    - system: True
    - gid_from_name: True
    - password: '*'
  group.present:
    - system: True
  service.running:
    - enable: True
    - require:
      - file: {{ logstash_log_dir }}
    - watch:
      - file: /etc/logstash/conf.d/*
      - pkg: logstash
