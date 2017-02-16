# encoding: utf-8
# author: Jonathan Morley (morley.jonathan@gmail.com)

describe command('(Get-Command nuget).definition') do
  its('stdout') { should match /C:\\Program Files\\NuGet\\nuget.exe/ }
end

describe command('nuget') do
  it { should exist }
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/NuGet Version: 3\.4\.3/) }
end

describe command('nuget sources list') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match %r{repo1 \[Enabled\]\s+http://example.com/repo1} }
  its('stdout') { should_not match(/repo2/) }
  its('stdout') { should match %r{repo3 \[Disabled\]\s+http://example.com/repo3} }
end
