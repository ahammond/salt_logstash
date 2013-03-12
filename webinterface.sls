# So... we want Kibana, because it's "AWESOME" as opposed to just pretty good.

git:
  pkg:
    - installed

rvm:
  group:
    - present
  user.present:
    - gid: rvm
    - home: /home/rvm
    - require:
      - group: rvm

/srv:
  file.directory:
    - user: root
    - group: rvm
    - mode: 775
    - require:
      - group: rvm

https://github.com/rashidkpc/Kibana.git:
  git.latest:
    - rev: v0.2.0
    - runas: rvm
    - target: /srv/kibana
    - require:
      - file: /srv
      - pkg: git
      - user: rvm

{#rvm-deps:#}
{#  pkg.installed:#}
{#    - names:#}
{#      - bash#}
{#      - coreutils#}
{#      - gzip#}
{#      - bzip2#}
{#      - gawk#}
{#      - sed#}
{#      - curl#}
{#      - git-core#}
{#      - subversion#}
{##}
{#mri-deps:#}
{#  pkg.installed:#}
{#    - names:#}
{#      - build-essential#}
{#      - openssl#}
{#      - libreadline6#}
{#      - libreadline6-dev#}
{#      - curl#}
{#      - git-core#}
{#      - zlib1g#}
{#      - zlib1g-dev#}
{#      - libssl-dev#}
{#      - libyaml-dev#}
{#      - libsqlite3-0#}
{#      - libsqlite3-dev#}
{#      - sqlite3#}
{#      - libxml2-dev#}
{#      - libxslt1-dev#}
{#      - autoconf#}
{#      - libc6-dev#}
{#      - libncurses5-dev#}
{#      - automake#}
{#      - libtool#}
{#      - bison#}
{#      - subversion#}
{#      - ruby#}
{##}
{#\curl -#L https://get.rvm.io | bash -s stable --ruby:#}
{#  cmd.run:#}
{#    - cwd: /srv#}
{#    - runas: rvm#}
{#    - require:#}
{#      - pkg: rvm-deps#}
{#      - pkg: mri-deps#}
{#      - user: rvm#}
{#    - unless: test -x /usr/local/rvm/bin/rvm#}
{##}
{#/usr/local/rvm/bin/gem-ruby-1.9.3-p392 install bundler:#}
{#  cmd.run:#}
{#    - runas: rvm#}
{#    - require:#}
{#      - cmd: \curl -#L https://get.rvm.io | bash -s stable --ruby#}
{#    - unless: test -x /usr/local/rvm/rubies/default/bin/gem#}
{##}
{#/usr/local/rvm/rubies/default/bin/bundler install:#}
{#  cmd.run:#}
{#    - cwd: /srv/kibana#}
{#    - runas: rvm#}
{#    - require:#}
{#      - git: https://github.com/rashidkpc/Kibana.git#}
{#      - cmd: /usr/local/rvm/bin/gem-ruby-1.9.3-p392 install bundler:#}

kibana:
  group.present:
    - system: True
  user.present:
    - gid: kibana
    - system: True
    - require:
      - group: kibana

# edit KibanaConfig.rb to find Elasticsearch

# run ruby kibana.rb
