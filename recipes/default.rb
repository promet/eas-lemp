#
# Cookbook Name:: eas-lemp
# Recipe:: default
#
# Copyright (C) 2014 opscale
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# add additional user
include_recipe 'eas-base'
include_recipe 'nginx'
include_recipe 'nginx::commons_conf'

include_recipe 'php'
# modules installs are deprecated in php
%w(php5-mysql php5-mcrypt php-apc php5-gd php5-memcache php5-curl).each do |pkg|
  package pkg do
    action :install
  end
end

include_recipe 'composer'
include_recipe 'php-fpm'

# service 'php5-fpm' do
#  action [:enable, :start]
# end


template '/etc/php5/mods-available/apc.ini' do
  source "apc.ini.erb"
  owner "root"
  group 0
  mode 00644
  notifies :reload, 'service[php-fpm]'
end

template "#{node['eas_lemp']['fpm_dir']}/php.ini" do
  source "php.ini.erb"
  owner "root"
  group 0
  mode 00644
  notifies :reload, 'service[php-fpm]'
end

include_recipe 'mysql::server'

mysql_service 'default' do
  allow_remote_root true
  remove_anonymous_users true
  remove_test_database false
  server_root_password 'easmysql'
  server_repl_password 'replpass'
  server_debian_password 'debianpass'
  action :create
end

template '/etc/mysql/conf.d/my-local.cnf' do
  owner 'mysql'
  owner 'mysql'
  source 'my-local.cnf.erb'
  notifies :restart, 'mysql_service[default]'
end
