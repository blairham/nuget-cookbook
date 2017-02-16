#
# Author:: Jonathan Morley (morley.jonathan@gmail.com)
# Cookbook Name:: nuget
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

include Windows::Helper

module Nuget
  module Helper
    def config_path(scope)
      case scope
      when :machine
        win_friendly_path("#{ENV['ProgramData']}/NuGet/Config/NuGet.config")
      when :user
        win_friendly_path("#{ENV['AppData']}/NuGet/NuGet.config")
      else
        raise "Invalid scope (#{scope}) provided"
      end
    end

    def format_args(resource, *args)
      args.map do |arg|
        "-#{arg.to_s.split('_').collect(&:capitalize).join} \"#{resource.send(arg)}\""
      end.join(' ')
    end

    def format_version(version)
      version == 'latest' ? version : "v#{version}"
    end

    def lookup_checksum(version, override)
      return override unless override.nil?
      case version
      when '3.5.0' then '399ec24c26ed54d6887cde61994bb3d1cada7956c1b19ff880f06f060c039918'
      when '3.4.4' then 'c12d583dd1b5447ac905a334262e02718f641fca3877d0b6117fe44674072a27'
      when '3.4.3' then '3b1ea72943968d7af6bacdb4f2f3a048a25afd14564ef1d8b1c041fdb09ebb0a'
      when '2.8.6' then 'a6be87794a542e3f518b718437443c6c29d379d12cc94bea7de787bf05babf83'
      end
    end
  end
end
