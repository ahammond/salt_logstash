openjdk-7-jre:
  pkg.latest:
    - refresh: True

/var/log/logstash:
  file.directory:
    - group: adm

logstash_ppa:
  pkgrepo.managed:
    - ppa: wolfnet/logstash

logstash:
  pkg.latest:
    - refresh: True
    - require:
      - pkgrepo: logstash_ppa
      - pkg: openjdk-7-jre
  user.present:
    - system: True
    - gid_from_name: True
    - password: '*'
  group.present:
    - system: True
  service.running:
    - enable: True
    - reload: True
    - require:
      - file: /var/log/logstash
    - watch:
      - file: /etc/logstash/conf.d/*
      - pkg: logstash
