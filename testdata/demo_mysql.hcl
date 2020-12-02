mysql {
  dataSourceName = "user:pass@tcp(127.0.0.1:3306)/db1?charset=utf8"
  dataKey = "upstreams"
  dataSql = "select name,keepalive,ip_hash ipHash,resolver,'{{servers}}' servers from t_upstreams where state='1'"
  sqls {
    servers = "select address,port,weight,max_conns maxConns,max_fails maxFails,fail_timeout failTimeout,backup,down,slow_start slowStart from t_servers where upstream_name='{{.name}}' and state='1'"
  }
}

tpl {
  dataSource = "mysql"
  # 不设置interval，将只会运行一次
  # 设置了interval，则会进入循环，每次间隔interval时间后，执行一次
  # interval = "10s"
  source = "testdata/upstreams.tpl"
  destination = "testdata/upstreams.conf"
  perms = 0600
  command = "echo reloaded"
}

