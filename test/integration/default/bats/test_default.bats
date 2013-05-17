#!/usr/bin/env bats

@test "checked out sensu-admin from git repo" {
    cd /opt/sensu/admin/website/current
    run git rev-parse
    [ $status -eq 0 ]
}

@test "starts unicorn" {
  run pgrep -f ^.*unicorn.*$
  [ $status -eq 0 ]
}

@test "starts nginx" {
  run pgrep -f ^.*nginx.*process.*$
  [ $status -eq 0 ]
}

@test "nginx is available on port 80" {
  run nc -z 0.0.0.0 80
  [ $status -eq 0 ]
}

@test "nginx is available on port 443" {
  run nc -z 0.0.0.0 443
  [ $status -eq 0 ]
}

@test "unicorn is available on port 8888" {
  run nc -z 0.0.0.0 8888
  [ $status -eq 0 ]
}

@test "http requests are redirected to https" {
  run curl -s -k --head http://0.0.0.0
  echo $output | grep "Location: https"
}
