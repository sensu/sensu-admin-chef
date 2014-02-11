#
# Cookbook Name:: sensu-admin
# Recipe:: nginx
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

package "nginx"

service "nginx" do
  supports :status => true, :restart => true, :reload => true
end

template "#{node.sensu.admin.base_path}/sensu-admin-nginx.conf" do
  user node.sensu.admin.user
  group node.sensu.admin.user
  source "sensu-admin-nginx.conf.erb"
  variables(:host => node.sensu.admin.host,
            :base_path => node.sensu.admin.base_path,
            :http_port => node.sensu.admin.http_port,
            :https_port => node.sensu.admin.https_port,
            :backend_port => node.sensu.admin.backend_port)
  notifies :restart, "service[nginx]", :delayed
end

link "/etc/nginx/sites-available/sensu-admin.conf" do
  to "#{node.sensu.admin.base_path}/sensu-admin-nginx.conf"
end

link "/etc/nginx/sites-enabled/sensu-admin.conf" do
  to "/etc/nginx/sites-available/sensu-admin.conf"
end

ssl = data_bag_item("sensu", "ssl")

file "#{node.sensu.admin.base_path}/server-cert.pem" do
  content ssl["client"]["cert"]
  mode 0644
end

file "#{node.sensu.admin.base_path}/server-key.pem" do
  content ssl["client"]["key"]
  mode 0600
end

