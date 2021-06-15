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
    ## note: hard code tournament / league for now
    @client ||= Client.new( league: 'euro', year: 2020 )    ## use "singelton" / shared client
  end



  def self.main
    puts banner # say hello

    what = ARGV[0] || 'today'
    what = what.downcase

    ## in the future make today "configurable" as param - why? why not?
    today = Date.today

    if ['yesterday', 'y', '-1'].include?( what )
      matches = client.yesterdays_matches
      if matches.empty?
         puts "** No matches played yesterday.\n"
      end
    elsif ['tomorrow', 't', '+1', '1'].include?( what )
      matches = client.tomorrows_matches
      if matches.empty?
         puts "** No matches scheduled tomorrow.\n"
      end
    elsif ['past', 'p', 'prev'].include?( what )
      matches = client.past_matches
      if matches.empty?
         puts "** No matches played yet.\n"
      end
    elsif ['upcoming', 'up', 'u', 'next', 'n'].include?( what )
      matches = client.upcoming_matches
      if matches.empty?
         puts "** No more matches scheduled.\n"
      end
    else
       matches = client.todays_matches

       ## no matches today
       if matches.empty?
          puts "** No matches scheduled today.\n"

          ## note: was world cup 2018 - end date -- Date.new( 2018, 7, 11 )
          if Date.today > Date.new( 2021, 7, 11 )   ## tournament is over, look back
            puts "Past matches:"
            matches = client.past_matches
          else  ## world cup is upcoming /in-progress,look forward
            puts "Upcoming matches:"
            matches = client.upcoming_matches
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

      print "%22s" % "#{match['team1']['name']} (#{match['team1']['code']})"

      ## todo/fix: add support for knockout scores
      ##                 with score1et/score1p  (extra time and penalty)
      if match['score1'] && match['score2']
        print " #{match['score1']}-#{match['score2']} "
        print "(#{match['score1i']}-#{match['score2i']}) "
      else
        print "    vs    "
      end

      print "%-22s" % "#{match['team2']['name']} (#{match['team2']['code']})"

      if match['group']
        print " #{match['group']} /"    ## group phase/stage
      end

      print " #{match['round']} "    ## knock out (k.o.) phase/stage

      if match['stadium']
        print " @ #{match['stadium']['name']}, #{match['city']}"
      end

      print "\n"


      if match['goals1'] && match['goals2']
        print "                     ["
        match['goals1'].each_with_index do |goal,i|
          print " "    if i > 0
          print "#{goal['name']}"
          print " #{goal['minute']}"
          print "+#{goal['offset']}"   if goal['offset']
          print "'"
          print " (o.g.)"    if goal['owngoal']
          print " (pen.)"    if goal['penalty']
        end
        match['goals2'].each_with_index do |goal,i|
          if i == 0
            print "; "
          else
           print " "
          end
          print "#{goal['name']}"
          print " #{goal['minute']}"
          print "+#{goal['offset']}"  if goal['offset']
          print "'"
          print " (o.g.)"  if goal['owngoal']
          print " (pen.)"  if goal['penalty']
        end
        print "]\n"
      end


    end
  end

end # module Footty



Footty.main  if __FILE__ == $0
