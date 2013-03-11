openjdk-7-jre:
  pkg.latest:
    - refresh: True

# NB: the PPA supplies 0.19.2 and Logstash recommends using 0.20.2.
# I've asked the PPA maintainer to update.
# In related news, the package in that PPA is completely and totally broken.
# Instead, let's download it from the interwebs.
# https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.20.5.deb
elasticsearch:
  pkg.installed:
    - sources:
      - elasticsearch: https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.20.5.deb
    - refresh: True
    - require:
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
      - pkg: elasticsearch
