openjdk-7-jre:
  pkg.latest:
    - refresh: True

/etc/default/elasticsearch:
  file.managed:
    - source: salt://logstash/files/etc/default/elasticsearch.sls
    - template: jinja

elasticsearch:
  pkg.installed:
    - sources:
      - elasticsearch: https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.20.5.deb
    - refresh: True
    - require:
      - pkg: openjdk-7-jre
      - file: /etc/default/elasticsearch
  service.running:
    - enable: True
    - watch:
      - pkg: elasticsearch
      - file: /etc/elasticsearch/elasticsearch.yml
      - file: /etc/default/elasticsearch

/etc/elasticsearch/elasticsearch.yml:
  file.managed:
    - source: salt://logstash/files/etc/elasticsearch/elasticsearch.yml
    - require:
      - pkg: elasticsearch

curl:
  pkg.installed

# Nightly optimize command.
curl -XPOST http://localhost:9200/logstash-$(date -d '1 day ago' +'%Y.%m.%d')/_optimize:
  cron.present:
    - user: elasticsearch
    - minute: 7
    - hour: 0
    - require:
      - pkg: curl

# support for elasticsearch monitoring via paramedic:
# http://166.78.143.218:9200/_plugin/paramedic/index.html
/usr/share/elasticsearch/bin/plugin -install karmi/elasticsearch-paramedic:
  cmd.run:
    - unless: test -x /usr/share/elasticsearch/plugins/paramedic
