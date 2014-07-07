require 'hoe'
require './lib/ojogo/version.rb'

Hoe.spec 'ojogo' do

  self.version = Ojogo::VERSION

  self.summary = 'ojogo - sport.db (incl. football.db) client - who is playing today?'
  self.description = summary

  self.urls = ['https://github.com/sportdb/ojogo.ruby']

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
   :required_ruby_version => '>= 1.9.2'
  }
end
