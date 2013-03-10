openjdk-7-jre:
  pkg.latest:
    - refresh: True

# NB: the PPA supplies 0.19.2 and Logstash recommends using 0.20.2.
# I've asked the PPA maintainer to update.
elasticsearch:
  pkgrepo.managed:
    - name: deb http://ppa.launchpad.net/eslam-husseiny/elasticsearch/ubuntu precise main
    - dist: precise
    - file: /etc/apt/sources.list.d/elasticsearch.list
    - keyid: 14563446182A24206CC7E9615D8DC766EFA56D49
    - keyserver: keyserver.ubuntu.com
    - require_in:
      - pkg: elasticsearch
  pkg.latest:
    - refresh: True
    - require:
      - pkgrepo: deb http://ppa.launchpad.net/eslam-husseiny/elasticsearch/ubuntu precise main
      - pkg: openjdk-7-jre
  user.present:
    - system: True
    - home: /srv/elasticsearch
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
