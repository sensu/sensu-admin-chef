#
# Cookbook Name:: sensu-admin
# Recipe:: unicorn
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

gem_package "unicorn"

template "#{node.sensu.admin.base_path}/sensu-admin-unicorn.rb" do
  user node.sensu.admin.user
  group node.sensu.admin.user
  source "sensu-admin-unicorn.rb.erb"
  variables(:workers => node.cpu.total.to_i + 1,
            :base_path => node.sensu.admin.base_path,
            :backend_port => node.sensu.admin.backend_port)
end

template "/etc/init.d/sensu-admin" do
  source "unicorn.init.erb"
  owner "root"
  group "root"
  mode "0755"
  variables(:base_path => node.sensu.admin.base_path)
end

