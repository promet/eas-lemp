normal['apt']['compile_time_update'] = true

normal['nginx']['server_tokens'] = 'off'
normal['nginx']['default_site_enabled'] = false
normal['nginx']['keepalive_timeout'] = 15
normal['nginx']['proxy_read_timeout'] = 20
normal['nginx']['worker_connections'] = 5000
normal['nginx']['client_max_body_size'] = '50'


# passwords
normal['mysql']['server_root_password'] = 'easmysql'
normal['mysql']['server_debian_password'] = 'debianpass'
normal['mysql']['server_repl_password'] = 'replpass'
