#
# Cookbook Name:: sensu-admin
# Recipe:: default
#
# Copyright 2012, Sonian Inc.
# Copyright 2012, Needle Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Note: This default install uses sqlite, which uses a file on the HD, if you lose this file your audit, downtime and user audits/logs will be gone.
# If this is important to you - BACK IT UP, or use a SQL DB thats already backed up for you.
#

# deal with some platform specific stuff 
# - start of getting rhel/centos & fedora working
case node['platform_family']
when "debian"
  if node['platform'] == "ubuntu" && node['platform_version'].to_f < 10.10
    package "git-core"
  else
    package "git"
  end
when "rhel","fedora"
  case node['platform_version'].to_i
  when 5
    include_recipe "yum::epel"
  end
  package "git"
else
  package "git"
end

package "sqlite3"
package "libsqlite3-dev"

# bundle install fails unless the mysql c libraries are available
include_recipe "mysql-chef_gem::default"


user node.sensu.admin.user do
  home node.sensu.admin.base_path
  system true
end

gem_package "bundler"
gem_package "rake" do
  version "0.9.2.2"
end

directory node.sensu.admin.base_path do
  owner node.sensu.admin.user
  group node.sensu.admin.user
  mode '0755'
  recursive true
end

# Otherwise chef is making the child directories owned by root (under recursive true)
%w{ website
    website/shared
    website/shared/config
    website/shared/log
    website/shared/db
    website/shared/bundle
    website/shared/pids }.each do |dir|
  directory "#{node.sensu.admin.base_path}/#{dir}" do
    owner node.sensu.admin.user
    group node.sensu.admin.user
    mode '0755'
    recursive true
  end
end

# install frontend (default nginx)
unless node[:sensu][:admin][:frontend] == "none"
  include_recipe "sensu-admin::#{node.sensu.admin.frontend}"
end

# install unicorn 
include_recipe "sensu-admin::unicorn"

# deploy sensu-admin code
include_recipe "sensu-admin::deploy"

service "sensu-admin" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
