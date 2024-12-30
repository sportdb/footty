require 'hoe'
require './lib/footty/version.rb'

Hoe.spec 'footty' do
  self.version = Footty::VERSION

  self.summary = "footty - football.db command line tool for national & int'l football club leagues (& cups) from around the world (bonus - incl. world cup, euro and more)"
  self.description = summary

  self.urls = { home: 'https://github.com/sportdb/footty' }

  self.author = 'Gerald Bauer'
  self.email  = 'gerald.bauer@gmail.com'

  # switch extension to .markdown for gihub formatting
  self.readme_file  = 'README.md'
  self.history_file = 'CHANGELOG.md'

  self.extra_deps = [
    ['sportdb-quick', '>= 0.2.0'],
    ['webget'],
  ]

  self.licenses = ['Public Domain']

  self.spec_extras = {
   required_ruby_version: '>= 3.1.0'
  }
end
