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

  def self.client
    @@client ||= Client.new    ## use "singelton" / shared client
  end



  def self.main
    puts banner # say hello

    what = ARGV[0] || 'today'
    what = what.downcase

    ## in the future make today "configurable" as param - why? why not?
    today = Date.today

    if ['yesterday', 'y', '-1'].include? what
      matches = client.get_yesterdays_matches( date: today )
      if matches.empty?
         puts "** No matches played yesterday.\n"
      end
    elsif ['tomorrow', 't', '+1', '1'].include? what
      matches = client.get_tomorrows_matches( date: today )
      if matches.empty?
         puts "** No matches scheduled tomorrow.\n"
      end
    elsif ['past', 'p', 'prev'].include? what
      matches = client.get_past_matches( date: today )
      if matches.empty?
         puts "** No matches played yet.\n"
      end
    elsif ['upcoming', 'up', 'u', 'next', 'n'].include? what
      matches = client.get_upcoming_matches( date: today )
      if matches.empty?
         puts "** No more matches scheduled.\n"
      end
    else
       matches = client.get_todays_matches( date: today )

       ## no matches today
       if matches.empty?
          puts "** No matches scheduled today.\n"

          if Date.today > Date.new( 2018, 7, 11 )   ## world cup is over, look back
            puts "Past matches:"
            matches = client.get_past_matches( date: today )
          else  ## world cup is upcoming /in-progress,look forward
            puts "Upcoming matches:"
            matches = client.get_upcoming_matches( date: today )
          end
       end
    end

    print_matches( matches )
  end



  def self.print_matches( matches )
    ## print games

    today = Date.today

    matches.each do |match|
      print "   %5s" % "\##{match['num']} "

      date = Date.parse( match['date'] )
      print "#{date.strftime('%a %b/%d')} "      ## e.g. Thu Jun/14
      if date > today
         diff = (date - today).to_i
         print "%10s" % "(in #{diff}d) "
      end

      print "%20s" % "#{match['team1']['name']} (#{match['team1']['code']})"
      print " vs "
      print "%20s" % "#{match['team2']['name']} (#{match['team2']['code']})"

      if match['group']
        print " #{match['group']} "    ## group phase/stage
      else
        print " #{match['round']} "    ## knock out (k.o.) phase/stage
      end

      print " @ #{match['stadium']['name']}, #{match['city']}"
      print "\n"
    end
  end

end # module Footty



Footty.main  if __FILE__ == $0
