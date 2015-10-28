rs.initiate()
rs.add('192.168.99.10:47029')
cfg = rs.conf()
cfg.members[0].host = '192.168.99.10:37029'
rs.reconfig(cfg)
rs.status()
