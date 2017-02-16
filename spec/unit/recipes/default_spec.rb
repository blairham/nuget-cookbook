# encoding: utf-8
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

require 'spec_helper'

describe 'nuget::default' do
  context 'When all attributes are default, on windows 2012R2' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'windows', version: '2012R2') do
        ENV['ProgramFiles'] = 'C:\\Program Files'
        ENV['ProgramData'] = 'C:\\ProgramData'
      end.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'creates the install directory' do
      expect(chef_run).to create_directory('C:\\Program Files\\NuGet').with(
        recursive: true
      )
    end

    it 'adds the install directory to the path' do
      expect(chef_run).to add_windows_path('C:\\Program Files\\NuGet')
    end

    it 'downloads latest nuget' do
      expect(chef_run).to create_remote_file('C:\\Program Files\\NuGet\\nuget.exe').with(
        source: 'https://dist.nuget.org/win-x86-commandline/latest/nuget.exe',
        checksum: nil
      )
    end

    context 'With a specific version' do
      let(:chef_run) do
        ChefSpec::ServerRunner.new(platform: 'windows', version: '2012R2') do |node|
          node.normal['nuget']['version'] = '3.5.0'
        end.converge(described_recipe)
      end

      it 'downloads specific version of nuget' do
        expect(chef_run).to create_remote_file('C:\\Program Files\\NuGet\\nuget.exe').with(
          source: 'https://dist.nuget.org/win-x86-commandline/v3.5.0/nuget.exe',
          checksum: '399ec24c26ed54d6887cde61994bb3d1cada7956c1b19ff880f06f060c039918'
        )
      end
    end
  end
end
