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

# Support for auto-pruning the indices
git:
  pkg.installed

basic_python_packages:
  pkg.installed:
    - pkgs:
      - python-pip
      - python-virtualenv

{% set prune_repo = 'https://github.com/ahammond/prune_logstash_elasticsearch.git' %}
{% set prune_dir = '/srv/prune_logstash_elasticsearch' %}
{% set prune_virtualenv = '{0}_virtualenv'.format(prune_dir) %}
{{ prune_repo }}:
  git.latest:
    - rev: master
    - target: {{ prune_dir }}
    - require:
      - pkg: git

{{ prune_virtualenv }}:
  virtualenv.managed:
    - requirements: {{ prune_dir }}/requirements.txt
    - require:
      - pkg: basic_python_packages
      - git: {{ prune_repo }}

{{ prune_virtualenv }}/bin/python {{ prune_dir }}/prune_logstash_elasticsearch.py:
  cron.present:
    - user: elasticsearch
    - minute: 57
    - require:
      - virtualenv: {{ prune_virtualenv }}

curl:
  pkg.installed

# Nightly optimize command.
/usr/bin/curl -XPOST http://localhost:9200/logstash-$(date -d '1 day ago' +'%Y.%m.%d')/_optimize:
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
