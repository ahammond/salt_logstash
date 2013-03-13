description "Kibana web interface to LogStash"

start on (net-device-up
          and local-filesystems
          and runlevel [2345])
stop on runlevel [!2345]

respawn
respawn limit 10 5

exec /sbin/start-stop-daemon --start --chuid postgres --chdir /srv/kibana --pidfile /var/run/kibana.pid --make-pidfile --exec /usr/local/rvm/bin/rvm {{ ruby }} do ruby /srv/kibana/kibana.rb
