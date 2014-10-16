#
# Cookbook Name:: eas-lemp
# Recipe:: ha_default_d7
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

include_recipe 'apt'
include_recipe 'git'
include_recipe 'cron'
include_recipe 'ntp'
include_recipe 'logrotate'
include_recipe 'vim'

node['eas-base']['all_users'].each do |user_group|
  users_manage user_group do
    data_bag 'users'
  end
end

include_recipe 'sudo'
include_recipe 'postfix'
include_recipe 'eas-base::_rsyslog'
include_recipe 'nrpe'
include_recipe 'eas-base::_base_monitoring'

include_recipe 'eas-base::_route53' if node.attribute?('ec2')
include_recipe 'chef-client::cron'

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

include_recipe 'database::mysql'

#### RDS STUFF HERE ####

mysql_connection_info = {:host => "localhost",
                         :username => 'root',
                         :password => node['mysql']['server_root_password']}

# create DB user
 mysql_database 'testDB' do
   connection(
     :host     => 'localhost',
     :username => 'root',
     :password => node['mysql']['server_root_password']
    )
  action :create
end

mysql_database_user 'testDBA' do
  provider Chef::Provider::Database::MysqlUser
  connection mysql_connection_info
  database_name 'testDB'
  password 'testPASS'
  host 'localhost'
  privileges [:all]
  action :grant
end

#### END RDS STUFF ####

# create nginx site from template
   cookbook_file 'nginx-defaultd7-tmpl' do
     path '/etc/nginx/sites-enabled/drupal'
     action :create_if_missing
     notifies :restart, "service[nginx]", :immediately
   end

#
%w(sites_dir).each do |dir|
  directory node['drupal'][dir] do
    owner node['drupal']['user']
    group node['drupal']['group']
    recursive true
  end
end

template "/root/.my.cnf" do
  source "root.my.cnf.erb"
  owner "root"
  group node['mysql']['root_group']
  mode "0600"
end

# clone site
git "/var/www/sites/drupal" do
  repository "https://github.com/promet/eas-defaultd7.git"
  action :checkout
  user "www-data"
  group "www-data"
end

bash 'drupal-creds' do
  cwd  "/var/www/sites/drupal/sites/default"
  code <<-EOH
    ln -s test.settings.php settings.php
  EOH
end

include_recipe 'drupal::drush'

bash 'drush-si' do
  cwd  "/var/www/sites/drupal"
  code <<-EOH
    drush si -y --account-name=admin --account-pass=drupaladmin
  EOH
end

template "/root/.my.cnf" do
  source "root.my.cnf.erb"
  owner "root"
  group node['mysql']['root_group']
  mode "0600"
end

#### EXTRAS: Register the instance to an ELB ####
#
node['nginx']['domain'].each do |domain, config|

# associate webserver with an Elastic Load Balancer ONLY

aws_elastic_ip config['elastic_ip'] do
  aws_access_key 'AKIAJVRADK3WD7TXE5NQ'
  aws_secret_access_key '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'
  ip config['elastic_ip']
  action :associate
end

# set the route 53 record to the ELB server
include_recipe 'route53'

route53_record 'create a record' do
  name config['alt_url']
  value config['elb_dns']
  type 'CNAME'
  zone_id node['eas-base']['zone_id']
  aws_access_key_id 'AKIAJYBNKLCTMKBPAZHA'
  aws_secret_access_key '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'
  overwrite true
  action :create
end

end

