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

{#Commented out for performance / visibility during development.#}
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

ruby-2.0.0:
  rvm.installed:
    - runas: rvm
    - require:
      - pkg: rvm-deps
      - pkg: mri-deps
      - user: rvm

/usr/local/rvm/bin/rvm ruby-2.0.0 do gem install bundler:
  cmd.run:
    - runas: rvm
    - require:
      - rvm: ruby-2.0.0
{#    - unless: test -x /usr/local/rvm/rubies/default/bin/gem#}
# I don't yet have a good way of detecting if bundler has been installed.

/usr/local/rvm/bin/rvm ruby-2.0.0 do bundle install:
  cmd.run:
    - cwd: /srv/kibana
    - runas: rvm
    - require:
      - git: https://github.com/rashidkpc/Kibana.git
      - cmd: /usr/local/rvm/bin/rvm ruby-2.0.0 do gem install bundler
{#    - unless: ???#}

/srv/kibana/KibanaConfig.rb
  # Bind to the default port.
  # We'll probably want to remove this once we put nginx in front of this.
  file.sed
    - before: '127.0.0.1'
    - after:  '0.0.0.0'
    - limit: '^  KibanaHost = '
    - require:
      - git: https://github.com/rashidkpc/Kibana.git
  file.sed
    - before: 'localhost:9200'
    - after: 'lselasticsearch01:9200'
    - limit: '^  Elasticsearch = '
    - require:
      - git: https://github.com/rashidkpc/Kibana.git

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
