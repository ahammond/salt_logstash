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
    - require:
      - pkgrepo: deb http://ppa.launchpad.net/rwky/redis/ubuntu precise main
{#  file.managed:#}
{#    - name: /etc/redis.conf#}
{#    - source: salt://logstash/redis.conf.jinja#}
{#    - template: jinja#}
{#    - defaults:#}
{#      - bind: 0.0.0.0#}
{#      - port: 6379#}
{#      - maxmemory: 0#}
{#    - require:#}
{#      - pkg: redis-server#}
  service.running:
    - enable: True
    - reload: True
    - require:
      - pkg: redis-server
      - sysctl: vm.overcommit_memory
{#    - watch:#}
{#      - file: /etc/redis/redis.conf#}

vm.overcommit_memory:
  sysctl.present:
    - value: 1
    - config: /etc/sysctl.d/10-redis.conf
