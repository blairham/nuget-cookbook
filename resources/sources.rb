#
# Author:: Jonathan Morley (morley.jonathan@gmail.com>)
# Cookbook Name:: nuget
# Resource:: source
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

include Nuget::Helper

property :name, String, name_attribute: true
property :scope, [:user, :machine], default: :machine
property :config_file, String, identity: true, default: lazy { config_path(scope) }
property :source, [String, nil], desired_state: false
property :enabled, [true, false], desired_state: false

default_action :add

load_current_value do
  require 'nokogiri'

  current_value_does_not_exist! unless ::File.exist?(config_file)
  config = ::File.open(config_file) { |f| Nokogiri::XML(f) }

  config_source = config.xpath("/configuration/packageSources/add[@key='#{name}']").first
  current_value_does_not_exist! if config_source.nil?

  source config_source.attribute('value').text
  enabled config.xpath("/configuration/disabledPackageSources/add[@key='#{name}' and @value='true']").empty?
end

action_class do
  include Nuget::Helper
end

action :add do
  converge_if_changed do
    directory ::File.dirname(config_file) do
      action :create
      recursive true
    end

    file config_file do
      action :create_if_missing
      rights :write, 'Everyone'
      content '<?xml version="1.0" encoding="utf-8"?><configuration />'
    end

    cmd = ['nuget sources',
           current_value.nil? ? 'Add' : 'Update',
           format_args(new_resource, :config_file, :name, :source),
          ].join(' ')

    execute "add nuget source (#{new_resource.name})" do
      action :run
      command cmd
    end
  end
end

action :remove do
  execute "remove nuget source (#{new_resource.name})" do
    action :run
    command "nuget sources Remove #{format_args(new_resource, :config_file, :name)}"
  end unless current_value.nil?
end

action :enable do
  new_resource.enabled = true

  converge_if_changed :enabled do
    execute "enable nuget source (#{new_resource.name})" do
      action :run
      command "nuget sources Enable #{format_args(new_resource, :config_file, :name)}"
    end
  end
end

action :disable do
  new_resource.enabled = false

  converge_if_changed :enabled do
    execute "disable nuget source (#{new_resource.name})" do
      action :run
      command "nuget sources Disable #{format_args(new_resource, :config_file, :name)}"
    end
  end
end
