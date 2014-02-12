# admin
default.sensu.admin.user = "sensu-admin"
default.sensu.admin.group = "sensu-admin"
default.sensu.admin.host = "localhost"
default.sensu.admin.http_port = 80
default.sensu.admin.https_port = 443
default.sensu.admin.backend_port = 8888
default.sensu.admin.repo = "https://github.com/sensu/sensu-admin.git"
default.sensu.admin.release = "v0.0.7" # Version locked, if you want the latest use development, if you want some stability use master. YMMV.
default.sensu.admin.base_path = "/opt/sensu/admin" # Omnibus sensu lives here
default.sensu.admin.frontend = "nginx" # nginx or apache for user facing http
