name              'nuget'
maintainer        'Blair Hamilton'
maintainer_email  'bhamilton@draftkings.com'
source_url        'https://github.com/blairham/nuget-cookbook'
issues_url        'https://github.com/blairham/nuget-cookbook/issues'
license           'Apache 2.0'
description       'Installs/Configures nuget'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))

version '2.0.0'

supports 'windows', '>= 6.1'

depends 'windows'

gem 'nokogiri'
