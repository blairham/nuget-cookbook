#
# Author:: Jonathan Morley (morley.jonathan@gmail.com)
# Cookbook Name:: nuget
# Recipe:: default
#
# Copyright 2017, Jonathan Morley
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

::Chef::Resource::RemoteFile.send(:include, Nuget::Helper)
::Chef::Recipe.send(:include, Windows::Helper)

install_dir = win_friendly_path(node['nuget']['install_dir'])

directory install_dir do
  action :create
  recursive true
end

windows_path install_dir do
  action :add
end

remote_file win_friendly_path(::File.join(install_dir, 'nuget.exe')) do
  action :create
  source format(node['nuget']['url'], format_version(node['nuget']['version']))
  checksum lookup_checksum(node['nuget']['version'], node['nuget']['checksum'])
end
