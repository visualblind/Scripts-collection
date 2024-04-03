#
# Cookbook Name:: nginx
# Attributes:: default
#
# Author:: Damian Curry (<damian.curry@nginx.com>)
#
# Copyright (c) 2017-present, NGINX, Inc.
#
# This source code is licensed under the Apache License (v2.0) found in the LICENSE file in
# the root directory of this source tree.
#

# In order to update the version, the checksum attribute must be changed too.
# This attribute is in the source.rb file, though we recommend overriding
# attributes by modifying a role, or the node itself.
default['nginx']['install_source'] = 'opensource'
default['nginx']['dir']            = '/etc/nginx'
default['nginx']['log_dir']        = '/var/log/nginx'
default['nginx']['nginx_repo_crt'] = nil
default['nginx']['nginx_repo_key'] = nil

#nginx.conf variables
default['nginx']['pid']                   = '/var/run/nginx.pid'
default['nginx']['user']                  = 'nginx'
default['nginx']['group']                 = 'nginx'
default['nginx']['worker_processes']      = 'auto'
default['nginx']['worker_connections']    = 1024
default['nginx']['tcp_nopush']            = 'off'
default['nginx']['enable_streams']        = false
default['nginx']['stream_conf_dir']       = "#{node['nginx']['dir']}/streams-conf/*.conf"
default['nginx']['error_log_level']       = 'error'

#plus only status page
default['nginx']['plus_status_enable']        = false
default['nginx']['plus_status_port']          = "8080"
default['nginx']['plus_status_allowed_ips']   = nil
default['nginx']['enable_upstream_conf']      = false
default['nginx']['plus_status_server_name']   = 'status-page'

#amplify agent
default['nginx']['amplify_api_key']      = nil
