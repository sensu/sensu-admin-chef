## DESCRIPTION

Installs [sensu-admin](https://github.com/sensu/sensu-admin), a web interface for the Sensu API.

## TESTING

This cookbook uses [test-kitchen](https://github.com/opscode/test-kitchen/). To converge and run tests:
```
gem install bundler
bundle install
bundle exec kitchen verify
```

Once converged, you may connect to the test-kitchen VM's IP in your browser and login as admin@example.com with the password 'secret'.

## COOKBOOK DEPENDENCIES

* [mysql](http://community.opscode.com/cookbooks/mysql) - mysql::ruby recipe required to satisify mysql2 gem prerequisites
* [ruby](http://community.opscode.com/cookbooks/ruby) - only used by Vagrantfile

## REQUIREMENTS

### SSL configuration

You can either generate a self-signed certificate by leaving `node.sensu.admin.ssl.generate`
as `true`, or you can use the data bag example.

For ease of use with Vagrant, example ssl data is included in the data_bags directory. 
Please don't use this certificate in a live environment.

## RECIPES

### sensu-admin::default

Installs sensu-admin rails app running on unicorn, front-ended by an nginx proxy.

## ATTRIBUTES

`node.sensu.admin.user` - user to run sensu-admin as, defaults to 'sensu'

`node.sensu.admin.group` - ditto above

`node.sensu.admin.host` - hostname which nginx is configured to proxy for

`node.sensu.admin.http_port` - nginx http port, defaults to '80'

`node.sensu.admin.https_port` - nginx https port, defaults to '443'

`node.sensu.admin.backend_port` - unicorn port, defaults to '8888'

`node.sensu.admin.repo` - repo url for sensu-admin app

`node.sensu.admin.release` - specifies revision of sensu-admin to deploy

`node.sensu.admin.base_path` - path where sensu-admin will be deployed, defaults to '/opt/sensu/admin'

`node.sensu.admin.ssl.generate` - whether or not to generate SSL certificates for nginx. defaults to `true`

`node.sensu.admin.ssl.subject` - info used when generating the SSL certificate.

## TODO

* Consider using nginx and/or unicorn cookbooks to configure those components in a more flexible manner.

* Instrument database configuration (allow choice of sqlite, mysql, etc.)

* Run bundler with --without-mysql when using sqlite (then we can skip including mysql::ruby recipe)

* Use LWRPs from database cookbook to configure database when using mysql or similar, and configure the app for that case
