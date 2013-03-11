openjdk-7-jre:
  pkg.latest:
    - refresh: True

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
    - require:
      - user: elasticsearch
      - group: elasticsearch
    - watch:
      - pkg: elasticsearch
