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
  service.running:
    - enable: True
    - reload: True
    - watch:
      - pkg: elasticsearch
