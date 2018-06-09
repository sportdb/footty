# encoding: utf-8


## stdlibs

require 'net/http'
require 'uri'
require 'json'
require 'pp'


## 3rd party gems/libs
## require 'props'

require 'logutils'
require 'fetcher'

# our own code

require 'footty/version' # let it always go first
require 'footty/client'


module Footty

  def self.banner
    "footty/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.root
    "#{File.expand_path( File.dirname(File.dirname(__FILE__)) )}"
  end



  def self.client
    @@client ||= Client.new    ## use "singelton" / shared client
  end




  def self.main
    puts banner # say hello

    games = client.get_todays_games()
    ## pp games

    ## print games
    games.each do |game|
      print "   "
      print "#{game['team1_title']} (#{game['team1_code']})"
      print " vs "
      print "#{game['team2_title']} (#{game['team2_code']})"
      print "\n"
    end
  end

end # module Footty



Footty.main  if __FILE__ == $0
