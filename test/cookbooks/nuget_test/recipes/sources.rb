#
# Author:: Jonathan Morley (morley.jonathan@gmail.com)
# Cookbook Name:: nuget_test
# Recipe:: sources
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

include_recipe 'nuget'

nuget_sources 'repo1' do
  action [:add, :enable]
  source 'http://example.com/repo1'
end

nuget_sources 'repo2' do
  action [:add, :remove]
  source 'http://example.com/repo2'
end

nuget_sources 'repo3' do
  action [:add, :disable]
  source 'http://example.com/repo3'
end
