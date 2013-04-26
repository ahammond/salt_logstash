#!pydsl
# So... we want Kibana, because it's "AWESOME" as opposed to just pretty good.

ruby = 'ruby-1.9.3'
github = 'https://github.com/rashidkpc/Kibana.git'
github_revision='v0.2.0'
deploy_directory='/srv/kibana'
kibana_group = 'kibana'
kibana_user = 'kibana'
rvm_base = '/usr/local/rvm'

# Find elasticsearch hosts
es_hosts = __salt__['publish.publish']('role:logstash.elasticsearch', 'grains.item', 'id', 'grain', TIMEOUT).keys()

es_string = ','.join(['"{}:9200"'.format(x) for x in es_hosts])

if len(es_hosts) > 1:
    elasticsearch_hosts = '[{}]'.format(es_string)
elif len(es_hosts) == 1:
    elasticsearch_hosts = es_string
else:
    raise ValueError("Can't configure kibana until at least one logstash.elasticsearch instance is deployed")


rvm_packages = [
    'bash',
    'coreutils',
    'gzip',
    'bzip2',
    'gawk',
    'sed',
    'curl',
    'git-core',
    'subversion',
]

mri_packages = [
    'build-essential',
    'openssl',
    'libreadline6',
    'libreadline6-dev',
    'curl',
    'git-core',
    'zlib1g',
    'zlib1g-dev',
    'libssl-dev',
    'libyaml-dev',
    'libsqlite3-0',
    'libsqlite3-dev',
    'sqlite3',
    'libxml2-dev',
    'libxslt1-dev',
    'autoconf',
    'libc6-dev',
    'libncurses5-dev',
    'automake',
    'libtool',
    'bison',
    'subversion',
    'ruby',
]

state('rvm-deps').pkg.installed(names=rvm_packages)
state('mri-deps')
    .pkg.installed(names=mri_packages)\
    .require(pkg='rvm-deps')

state('git').pkg.installed()

state(github)\
    .git.latest(
          rev=github_revision,
          target=deploy_directory)\
    .require(pkg='git')


state(ruby)\
    .rvm.installed()\
    .require(pkg='mri-deps')

state(rvm_base)\
    .file.directory(mode='2775')\
    .require(rvm=ruby)

bundler_install = '{0}/bin/rvm {1} do gem install bundler'.format(rvm_base, ruby)
state(bundler_install)\
    .cmd.run()\
    .require(rvm=ruby)\
    .unless('ls -d {0}/gems/{1}*/gems/bundler* > /dev/null'.format(rvm_base, ruby))

bundle_install = '{0}/bin/rvm {1} do bundle install'.format(rvm_base, ruby)
state(bundle_install)\
    .cmd.run(cwd=deploy_directory)\
    .require(
        git=github,
        cmd=bundler_install)
# I don't yet have a good way of detecting if bundle has been installed.

kibana_config = '{}/KibanaConfig.rb'.format(deploy_directory)
state(kibana_config)\
    .file.managed(
        source='salt://logstash/files{}'.format(kibana_config),
        template='jinja',
        elasticsearch_hosts=elasticsearch_hosts)\
    .require(git=github)

kibana_init_defaults = {
    'ruby': ruby,
}
kibana_init='/etc/init/kibana.conf'
state(kibana_init)\
    .file.managed(
        source='salt://logstash/files{}'.format(kibana_init),
        template='jinja',
        defaults=kibana_init_defaults)

state('kibana_group')\
    .group.present(
        name=kibana_group
        system=True)

state('kibana_user')\
    .user.present(
        name=kibana_name,
        home=deploy_directory,
        gid_from_name=True,
        system=True,
        groups=['rvm',])\
    .require(
        group='kibana_group',
        git=github)

state('kibana_service')\
    .service.running(
        name='kibana',
        enable=True,
        reload=True)\
    .require(
        file=kibana_init,
        cmd=bundle_install,
        git=github)\
    .watch(file=kibana_config)
