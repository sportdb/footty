require 'sportdb/quick'   ## note - pulls in cocos et al
require 'webget'    ## add webcache support

require 'optparse'




# our own code
require_relative 'footty/version' # let version always go first
require_relative 'footty/dataset'
require_relative 'footty/openfootball'

require_relative 'footty/print'



## set cache to local .cache dir for now - why? why not?
Webcache.root = './cache'
#  pp Webcache.root
Webget.config.sleep = 1  ## set delay in secs (to 1 sec - default is/maybe 3)


module Footty
  def self.main( args=ARGV )
    puts banner # say hello


    opts = {  debug:   false,
              verbose: false,    ## add more details
              ## add cache/cache_dir - why? why not?

              query:   nil,

              ## display format/mode  - week/window/upcoming/past (default is today)
              yesterday: nil,
              tomorrow:  nil,
              upcoming:  nil,
              past:      nil,

              #  week:      nil,
              #  window:    nil,   ## 2 day plus/minus  +2/-2
           }

           
    parser = OptionParser.new do |parser|
      parser.banner = "Usage: #{$PROGRAM_NAME} [options] LEAGUES"

      parser.on( "--verbose", 
                 "turn on verbose output (default: #{opts[:verbose]})" ) do |verbose|
        opts[:verbose] = true
      end   

      parser.on( "-q NAME", "--query",
                   "query mode; display matches where team name matches query" ) do |query|
        opts[:query] = query
      end


      parser.on( "-y", "--yesterday" ) do |yesterday|
        opts[:yesterday] = true
      end
      parser.on( "-t", "--tomorrow" ) do |tomorrow|
        opts[:tomorrow] = true
      end
      parser.on( "-p", "--past" ) do |past|
        opts[:past] = true
      end
      parser.on( "-u", "--up", "--upcoming" ) do |upcoming|
        opts[:upcoming] = true
      end
    end
    parser.parse!( args )


    puts "OPTS:"
    p opts
    puts "ARGV:"
    p args


    ###
    ##   use simple norm(alize) args (that is,) league codes for now
    ##      - downcase, strip dot (.) etc.)
    ##   e.g.  en.facup   => enfacup
    ##         at.cup     => atcup     etc.
    args = args.map { |arg| arg.downcase.gsub( /[._-]/, '' ) }



    ######################
    ## note - first check for buil-in "magic" commands
    ##   e.g. leagues / codes    -  dump built-in league codes

    if args.include?( 'leagues' ) 
       puts "==> openfootball dataset sources:"
       pp OpenfootballDataset::SOURCES
       
       ## pretty print keys/codes only
       puts  
       puts OpenfootballDataset::SOURCES.keys.join( ' ' )
       puts "   #{OpenfootballDataset::SOURCES.keys.size} league code(s)"

       exit 1
    end




    
    top = [['world',   '2022'],
           ['euro',   '2024'],
           ['mx',     '2024/25'],
           ['copa',   '2025'],       ## copa libertadores
           ['en',     '2024/25'],
           ['es',     '2024/25'],
           ['it',     '2024/25'],
           ['fr',     '2024/25'],
           ['de',     '2024/25'],
           ['at',     '2024/25'],
           ['champs', '2024/25'],
          ]
 
          
    leagues =  if args.size == 0
                   top
               else
                   ### auto-fill (latest) season/year 
                   args.map do |arg| 
                              [arg, OpenfootballDataset.latest_season( league: arg )]  
                            end
               end


    ## fetch leagues
    datasets =  leagues.map do |league, season|
                                dataset = OpenfootballDataset.new( league: league, season: season )
                                ## parse matches
                                matches = dataset.matches
                                puts "  #{league} #{season} - #{matches.size} match(es)"                                 
                                dataset
                            end                     
    
  

    ###################
    ##  check for query option to filter matches by query (team)
    if opts[:query]
      q = opts[:query]
      puts
      puts
      datasets.each do |dataset|
        matches = dataset.query( q )

        if matches.size == 0
           ## siltently skip for now
        else  ## assume matches found
          print "==> #{dataset.league_name}"
          print "   #{dataset.start_date} - #{dataset.end_date}"
          print "   -- #{dataset.matches.size} match(es)"
          print "\n"
          print_matches( matches )
        end
      end
      exit 1
    end


    # Dataset.new( league: 'euro', year: 2024 )
    # dataset = Dataset.new( league: league, year: year )

    ## in the future make today "configurable" as param - why? why not?
    today = Date.today


     what =  if opts[:yesterday]
               'yesterday'
             elsif opts[:tomorrow]
               'tomorrow'
             elsif opts[:past]
               'past'
             elsif opts[:upcoming]
               'upcoming'
             else
               'today'
             end


    ## start with two empty lines - assume (massive) debug output before ;-)
    puts
    puts
    datasets.each do |dataset|
      print "==> #{dataset.league_name}"
      print "   #{dataset.start_date} - #{dataset.end_date}"
      print "   -- #{dataset.matches.size} match(es)"
      print "\n"

      if what == 'yesterday'
        matches = dataset.yesterdays_matches
        if matches.empty?
           puts (' '*4) + "** No matches played yesterday.\n"
        end
      elsif what == 'tomorrow'
        matches = dataset.tomorrows_matches
        if matches.empty?
           puts (' '*4) + "** No matches scheduled tomorrow.\n"
        end
      elsif what == 'past'
        matches = dataset.past_matches
        if matches.empty?
           puts (' '*4) + "** No matches played yet.\n"
        end
      elsif what == 'upcoming'
        matches = dataset.upcoming_matches
        if matches.empty?
           puts (' '*4) + "** No more matches scheduled.\n"
        end
      else   ## assume today
         matches = dataset.todays_matches

         ## no matches today
         if matches.empty?
            puts (' '*4) + "** No matches scheduled today.\n"

            if opts[:verbose]
              ## note: was world cup 2018 - end date -- Date.new( 2018, 7, 11 )
              ## note: was euro 2020 (in 2021) - end date -- Date.new( 2021, 7, 11 )
              if Date.today > dataset.end_date    ## tournament is over, look back
                puts "Past matches:"
                matches = dataset.past_matches
              else  ## world cup is upcoming /in-progress,look forward
                puts "Upcoming matches:"
                matches = dataset.upcoming_matches( limit: 18 )
              end
            end
         end
       end
       print_matches( matches )
      end

  end # method self.main
end # module Footty




Footty.main  if __FILE__ == $0
