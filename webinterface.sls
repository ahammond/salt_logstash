# So... we want Kibana, because it's "AWESOME" as opposed to just pretty good.

git:
  pkg
    - installed


https://github.com/rashidkpc/Kibana.git:
  git.latest:
    - rev: v0.2.0
    - target: /srv/kibana
    - require:
      - pkg: git
