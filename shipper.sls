openjdk-7-jre-headless:
  pkg:
    - installed

logstash_ppa:
  pkgrepo.managed:
    - name: deb http://ppa.launchpad.net/wolfnet/logstash/ubuntu
    - distro: precise
    - file: /etc/apt/sources.list.d/logstash.list
    - keyid: 28B04E4A
    - keyserver: keyserver.ubuntu.com

logstash:
  pkg.installed
    - require:
      - pkgrepo: logstash_ppa
      - pkg: openjdk-7-jre-headless
  user.present:
    - system: True
    - home: /srv/logstash
    - shell: /usr/sbin/nologin
    - password: '*'

#apply standard configs?
#restart shipper if configs change
