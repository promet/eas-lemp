include_recipe 'mysql::server'

template '/etc/mysql/conf.d/my-local.cnf' do
  owner 'mysql'
  owner 'mysql'
  source 'my-local.cnf.erb'
  notifies :restart, 'mysql_service[default]'
end
