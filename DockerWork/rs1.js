rs.initiate()
rs.add('172.31.0.78:47001')
cfg = rs.conf()
cfg.members[0].host = '172.31.0.78:37001'
rs.reconfig(cfg,{force:true})
rs.status()
