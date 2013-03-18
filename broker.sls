deb http://ppa.launchpad.net/rwky/redis/ubuntu precise main:
  pkgrepo.managed:
    - dist: precise
    - file: /etc/apt/sources.list.d/redis.list
    - keyid: 5862E31D
    - keyserver: keyserver.ubuntu.com
    - require_in:
      - pkg: redis-server

redis-server:
  pkg.latest:
    - refresh: True
    - require:
      - pkgrepo: deb http://ppa.launchpad.net/rwky/redis/ubuntu precise main
  service.running:
    - enable: True
    - reload: True
    - require:
      - pkg: redis-server
      - sysctl: vm.overcommit_memory
      - file: /var/log/redis
    - watch:
      - file: /etc/redis/redis.conf

/var/log/redis:
  file.directory:
    - user: redis
    - group: adm
    - mode: 2750
    - require:
      - pkg: redis-server

/etc/redis/redis.conf:
  file.managed:
    - source: salt://logstash/files/etc/redis/redis.conf.jinja
    - template: jinja
    - defaults:
      bind: 0.0.0.0
      port: 6379
      maxmemory: 0
    - require:
      - pkg: redis-server

vm.overcommit_memory:
  sysctl.present:
    - value: 1
    - config: /etc/sysctl.d/10-redis.conf
