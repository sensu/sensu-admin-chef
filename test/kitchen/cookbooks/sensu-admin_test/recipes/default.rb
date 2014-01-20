#
# Cookbook Name:: sensu-admin_test
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

include_recipe "sensu-admin"

# remove default sites
case node[:sensu][:admin][:frontend]
when 'apache'
  link "/etc/apache2/sites-enabled/000-default" do
    action :delete
    only_if "test -L /etc/apache2/sites-enabled/000-default"
  end
else
  link "/etc/nginx/sites-enabled/default" do
    action :delete
    only_if "test -L /etc/nginx/sites-enabled/default"
  end
end
