#
# Cookbook Name:: etherpad
# Recipe:: lite
#
# Copyright 2013, computerlyrik
# Modifications by OpenWatch FPC
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

case node['platform_family']
  when "debian", "ubuntu"
    packages = %w{gzip git-core curl python libssl-dev pkg-config build-essential}
  when "fedora","centos"
    packages = %w{gzip git-core curl python openssl-devel}
    # && yum groupinstall "Development Tools"
end

packages.each do |p|
  package p
end

node.set['nodejs']['install_method'] = 'package'
include_recipe "nodejs"


user = node['etherpad-lite']['service_user']
group = node['etherpad-lite']['service_user_gid']
user_home = node['etherpad-lite']['service_user_home']
project_path = "#{user_home}/etherpad-lite"

user user do
  home user_home
  supports ({
    :manage_home => true
  })
  system true
end

git project_path do
  repository node['etherpad-lite']['etherpad_git_repo_url']
  action :sync
  user user
end

template "#{project_path}/settings.json" do
  owner user
  group group
  variables({
    :title => node['etherpad-lite']['title'],
    :favicon_url => node['etherpad-lite']['favicon_url'],
    :ip_address => node['etherpad-lite']['ip_address'],
    :port_number => node['etherpad-lite']['port_number'],
    :ssl_enabled => node['etherpad-lite']['ssl_enabled'],
    :ssl_key_path => node['etherpad-lite']['ssl_key_path'],
    :ssl_cert_path => node['etherpad-lite']['ssl_cert_path'],
    :db_type => node['etherpad-lite']['db_type'],
    :db_user => node['etherpad-lite']['db_user'],
    :db_host => node['etherpad-lite']['db_host'],
    :db_password => node['etherpad-lite']['db_password'],
    :db_name => node['etherpad-lite']['db_name'],
    :default_text => node['etherpad-lite']['default_text'],
    :require_session => node['etherpad-lite']['require_session'],
    :edit_only => node['etherpad-lite']['edit_only'],
    :minify => node['etherpad-lite']['minify'],
    :max_age => node['etherpad-lite']['max_age'],
    :abiword_path => node['etherpad-lite']['abiword_path'],
    :require_authentication => node['etherpad-lite']['require_authentication'],
    :require_authorization => node['etherpad-lite']['require_authorization'],
    :admin_enabled => node['etherpad-lite']['admin_enabled'],
    :admin_password => node['etherpad-lite']['admin_password'],
    :log_level => node['etherpad-lite']['log_level']
  })
end

etherpad_api_key = node['etherpad-lite']['etherpad_api_key']

if etherpad_api_key != ''
  template "#{project_path}/APIKEY.txt" do
    owner user
    group group
    variables({
      :etherpad_api_key => etherpad_api_key
    })
  end
end

node_modules = project_path + "/node_modules"


# Make Nginx log dirs
log_dir = node['etherpad-lite']['logs_dir']
access_log = log_dir + '/access.log'
error_log = log_dir + '/error.log'

# Upstart service config file
template "/etc/init/" + node['etherpad-lite']['service_name'] + ".conf" do
    source "upstart.conf.erb"
    owner user
    group group
    variables({
      :etherpad_installation_dir => project_path,
      :etherpad_service_user => user,
      :etherpad_access_log => access_log,
      :etherpad_error_log => error_log,
    })
end

# Nginx config file
template node['nginx']['dir'] + "/sites-enabled/etherpad.conf" do
    source "nginx.conf.erb"
    owner node['nginx']['user']
    group node['nginx']['group']
    variables({
      :domain => node['etherpad-lite']['domain'],
      :internal_port => node['etherpad-lite']['port_number'],
      :ssl_cert => node['etherpad-lite']['ssl_cert_path'],
      :ssl_key => node['etherpad-lite']['ssl_key_path'],
      :access_log => access_log,
      :error_log => error_log,
    })
    notifies :restart, "service[nginx]"
    action :create
end

directory log_dir do
  owner user
  group group
  recursive true
  action :create
end

# Make service log file
file access_log  do
  owner user
  group group
  action :create_if_missing # see actions section below
end

# Make service log file
file error_log  do
  owner user
  group group
  action :create_if_missing # see actions section below
end

## Install dependencies
bash "installdeps" do
  user 0
  cwd project_path
  code <<-EOH
  ./bin/installDeps.sh >> #{error_log}
  EOH
end

# Create and set permissions for node_modules
directory node_modules do
  owner user
  group group
  mode "770"
  recursive true
  action :create
end

npm_package "pg" do
  version "0.14.0"
  path project_path
  action :install_local
end

# Register capture app as a service
service node['etherpad-lite']['service_name'] do
  provider Chef::Provider::Service::Upstart
  action :start
end

