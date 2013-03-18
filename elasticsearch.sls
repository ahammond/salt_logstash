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

# support for elasticsearch monitoring via paramedic:
# http://166.78.143.218:9200/_plugin/paramedic/index.html
/usr/share/elasticsearch/bin/plugin -install karmi/elasticsearch-paramedic:
  cmd.run:
    - unless: text -x /usr/share/elasticsearch/plugins/paramedic
