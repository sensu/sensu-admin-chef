name              'sensu-admin'
maintainer        "Sonian, Inc."
maintainer_email  "chefs@sonian.net"
license           "Apache 2.0"
description       "installs and configures the sensu-admin web ui"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.1.1"
recipe            "sensu-admin", "installs nginx and sensu-admin"

%w{ ubuntu }.each do |os|
  supports os
end

%w{ mysql-chef_gem }.each do |cb|
  depends cb
end

