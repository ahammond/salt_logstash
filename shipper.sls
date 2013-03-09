logstash:
  pkgrepo.managed:
    - name: deb http://ppa.launchpad.net/wolfnet/logstash/ubuntu precise main
    - dist: precise
    - file: /etc/apt/sources.list.d/logstash.list
    - keyid: 28B04E4A
    - keyserver: keyserver.ubuntu.com
    - require_in:
      - pkg: logstash
  pkg.latest:
    - refresh: True
  user.present:
    - system: True
    - home: /srv/logstash
    - shell: /usr/sbin/nologin
    - password: '*'
  group.present:
    - system: True
  file.managed:
    - name: /etc/logstash/conf.d/syslog.conf
    - source: salt://logstash/logstash_syslog.conf
    - user: root
    - group: adm
    - mode: 640
    - template: jinja
    - require:
      - pkg: logstash
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/logstash/conf.d/*
      - pkg: logstash





#apply standard configs?
#restart shipper if configs change
