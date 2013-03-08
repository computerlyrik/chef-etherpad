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

user user do
  home user_home
  supports ({
    :manage_home => true
  })
  system true
end

git "#{user_home}/etherpad-lite" do
  repository node['etherpad-lite']['etherpad_git_repo_url']
  action :sync
  user user
end

template "#{user_home}/etherpad-lite/settings.json" do
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
  template "#{user_home}/etherpad-lite/APIKEY.txt" do
    owner user
    group group
    variables({
      :etherpad_api_key => etherpad_api_key
    })
end

service "etherpad-lite" do
  start_command "#{user_home}/etherpad-lite/bin/run.sh"
#  stop_command "#{user_home}/bin/stop.sh"
  action :start
  subscribes :restart, "#{user_home}/etherpad-lite"
end


