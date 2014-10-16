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
include_recipe 'aws'

node['drupals']['domain'].each do |site, config|

# associate webserver with an Elastic Load Balancer ONLY
  #aws_elastic_lb config['elb'] do
  aws_elastic_lb 'test-elb-1' do
    aws_access_key 'AKIAJVRADK3WD7TXE5NQ'
    aws_secret_access_key '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'
    name config['elb']
    action :register
  end

# set the route 53 record to the ELB server
  include_recipe 'route53'

  route53_record 'Create CNAME Record' do
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
