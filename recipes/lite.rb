#
# Cookbook Name:: etherpad
# Recipe:: lite
#
# Copyright 2013, computerlyrik
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


user = "etherpad-user"
user_home = "/etherpad"

user user do
  home user_home
  supports ({:manage_home => true})
  system true
end

git "#{user_home}/etherpad-lite" do
  repository "git://github.com/ether/etherpad-lite.git"
  action :sync
  user user
end

template "#{user_home}/etherpad-lite/settings.json" do
  owner user
end

service "etherpad-lite" do
  start_command "#{user_home}/etherpad-lite/bin/run.sh"
#  stop_command "#{user_home}/bin/stop.sh"
  action :start
  subscribes :restart, "#{user_home}/etherpad-lite"
end


