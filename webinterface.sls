# So... we want Kibana, because it's "AWESOME" as opposed to just pretty good.

{%  set ruby='ruby-1.9.3' -%}

git:
  pkg:
    - installed

https://github.com/rashidkpc/Kibana.git:
  git.latest:
    - rev: v0.2.0
    - target: /srv/kibana
    - require:
      - pkg: git

rvm-deps:
  pkg.installed:
    - names:
      - bash
      - coreutils
      - gzip
      - bzip2
      - gawk
      - sed
      - curl
      - git-core
      - subversion

mri-deps:
  pkg.installed:
    - names:
      - build-essential
      - openssl
      - libreadline6
      - libreadline6-dev
      - curl
      - git-core
      - zlib1g
      - zlib1g-dev
      - libssl-dev
      - libyaml-dev
      - libsqlite3-0
      - libsqlite3-dev
      - sqlite3
      - libxml2-dev
      - libxslt1-dev
      - autoconf
      - libc6-dev
      - libncurses5-dev
      - automake
      - libtool
      - bison
      - subversion
      - ruby

{{ ruby }}:
  rvm.installed:
    - require:
      - pkg: rvm-deps
      - pkg: mri-deps

/usr/local/rvm:
  file.directory:
    - mode: 2775
    - require:
      - rvm: {{ ruby }}

/usr/local/rvm/bin/rvm {{ ruby }} do gem install bundler:
  cmd.run:
    - require:
      - rvm: {{ ruby }}
    - unless: ls -d /usr/local/rvm/gems/{{ ruby }}*/gems/bundler* > /dev/null

/usr/local/rvm/bin/rvm {{ ruby }} do bundle install:
  cmd.run:
    - cwd: /srv/kibana
    - require:
      - git: https://github.com/rashidkpc/Kibana.git
      - cmd: /usr/local/rvm/bin/rvm {{ ruby }} do gem install bundler
# I don't yet have a good way of detecting if bundle has been installed.

/srv/kibana/KibanaConfig.rb:
  file.managed:
    - source: salt://logstash/files/srv/kibana/KibanaConfig.rb.sls
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - git: https://github.com/rashidkpc/Kibana.git

/etc/init/kibana.conf:
  file.managed:
    - source: salt://logstash/files/etc/init/kibana.conf.sls
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
      ruby: {{ ruby }}

kibana:
  group.present:
    - system: True
  user.present:
    - home: /srv/kibana
    - gid_from_name: True
    - system: True
    - groups:
      - rvm
    - require:
      - group: kibana
      - git: https://github.com/rashidkpc/Kibana.git
  service.running:
    - enable: True
    - reload: True
    - require:
      - file: /etc/init/kibana.conf
      - cmd: /usr/local/rvm/bin/rvm {{ ruby }} do bundle install
      - git: https://github.com/rashidkpc/Kibana.git
    - watch:
      - file: /srv/kibana/KibanaConfig.rb
