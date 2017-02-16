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

describe 'nuget_test::sources' do
  context 'When all attributes are default, on windows 2012R2' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'windows', version: '2012R2',
                                 step_into: ['nuget_sources']) do
        ENV['ProgramFiles'] = 'C:\\Program Files'
        ENV['ProgramData'] = 'C:\\ProgramData'
      end.converge(described_recipe)
    end

    it 'creates the config file' do
      expect(chef_run).to create_file_if_missing('C:\\ProgramData\\NuGet\\Config\\NuGet.config')
    end

    it 'generates the expected resources for repo1' do
      expect(chef_run).to add_nuget_sources('repo1')
      expect(chef_run).to run_execute('add nuget source (repo1)')

      expect(chef_run).to enable_nuget_sources('repo1')
      expect(chef_run).to run_execute('enable nuget source (repo1)')
    end

    it 'generates the expected resources for repo2' do
      expect(chef_run).to add_nuget_sources('repo2')
      expect(chef_run).to run_execute('add nuget source (repo2)')

      expect(chef_run).to remove_nuget_sources('repo2')
    end

    it 'generates the expected resources for repo3' do
      expect(chef_run).to add_nuget_sources('repo3')
      expect(chef_run).to run_execute('add nuget source (repo3)')

      expect(chef_run).to disable_nuget_sources('repo3')
      expect(chef_run).to run_execute('disable nuget source (repo3)')
    end
  end
end
