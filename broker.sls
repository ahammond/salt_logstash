redis-server:
  pkgrepo.managed:
    - name: deb http://ppa.launchpad.net/rwky/redis/ubuntu precise main
    - dist: precise
    - file: /etc/apt/sources.list.d/redis.list
    - keyid: 5862E31D
    - keyserver: keyserver.ubuntu.com
    - require_in:
      - pkg: redis-server
  pkg.latest:
    - refresh: True
  service.runing:
    - enable: True
    - reload: True
    - require:
      - pkg: redis-server



