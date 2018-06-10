require 'hoe'
require './lib/footty/version.rb'

Hoe.spec 'footty' do

  self.version = Footty::VERSION

  self.summary = 'footty - football.db command line client for world cup (russia 2018) and more - who is playing today?'
  self.description = summary

  self.urls = ['https://github.com/sportdb/footty']

  self.author = 'Gerald Bauer'
  self.email = 'opensport@googlegroups.com'

  # switch extension to .markdown for gihub formatting
  self.readme_file = 'README.md'
  self.history_file = 'HISTORY.md'

  self.extra_deps = [
    ['logutils' ],
    ['fetcher']
  ]

  self.licenses = ['Public Domain']

  self.spec_extras = {
   :required_ruby_version => '>= 2.3'
  }
end
