
## stdlibs

require 'net/http'
require 'uri'
require 'json'
require 'pp'


## 3rd party gems/libs
## require 'props'

require 'logutils'


# our own code

require 'ojogo/version' # let it always go first
require 'ojogo/client'


module Ojogo

  def self.banner
    "ojogo/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.root
    "#{File.expand_path( File.dirname(File.dirname(__FILE__)) )}"
  end
  
  def self.main
    puts banner # say hello
    
    client = Client.new
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

end # module Ojogo



Ojogo.main  if __FILE__ == $0
