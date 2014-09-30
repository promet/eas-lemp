include_recipe 'php'
# modules installs are deprecated in php
%w(php5-mysql php5-mcrypt php-apc php5-gd php5-memcache php5-curl).each do |pkg|
  package pkg do
    action :install
  end
end

include_recipe 'composer'
include_recipe 'php-fpm'

template '/etc/php5/mods-available/apc.ini' do
  source 'apc.ini.erb'
  owner 'root'
  group 0
  mode 00644
  notifies :reload, 'service[php-fpm]'
end

template "#{node['eas_lemp']['fpm_dir']}/php.ini" do
  source 'php.ini.erb'
  owner 'root'
  group 0
  mode 00644
  notifies :reload, 'service[php-fpm]'
end
