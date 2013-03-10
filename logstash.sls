openjdk-7-jre:
  pkg.latest:
    - refresh: True

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
    - require:
      - pkgrepo: logstash
      - pkg: openjdk-7-jre
  user.present:
    - system: True
    - home: /srv/logstash
    - shell: /usr/sbin/nologin
    - password: '*'
  group.present:
    - system: True
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/logstash/conf.d/*
      - pkg: logstash
