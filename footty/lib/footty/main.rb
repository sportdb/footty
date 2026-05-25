

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

              week:      false,
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

      parser.on( "-w", "--week",
                  "show matches of the (sport) week from tue to mon (default: #{opts[:week]})" ) do |week|
        opts[:week] = true
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



    top = [['world',   '2026'],   ## world cup (w/ national teams)
         #  ['euro',   '2024'],
         #  ['mls',    '2025'],
         #  ['concacafcl', '2025'],
         #  ['mx',     '2024/25'],
           ['en',     '2025/26'],
           ['es',     '2025/26'],
           ['it',     '2025/26'],
           ['fr',     '2025/26'],
           ['de',     '2025/26'],
         #  ['decup',  '2025/26'],
         #  ['at',     '2025/26'],
         #  ['atcup',   '2025/26'],
           ['uefacl',   '2025/26'],
         #  ['uefael',   '2025/26'],
         #  ['uefaconf', '2025/26'],
           ['br',     '2026'],
           ['copa',   '2026'],       ## copa libertadores  (not copa america,etc.)
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
             elsif opts[:week]
               'week'
             else
               'today'
             end


    ## if week get week number and start and end date (tuesday to mondey)
    if what == 'week'
      week_start, week_end = Footty.week_tue_to_mon( today)
      puts
      puts  "=== " + Footty.fmt_week( week_start, week_end ) + " ==="
    else
      ## start with two empty lines - assume (massive) debug output before ;-)
      puts
      puts
    end

    datasets.each do |dataset|
      print "==> #{dataset.league_name}"
      print "   #{dataset.start_date} - #{dataset.end_date}"
      print "   -- #{dataset.matches.size} match(es)"
      print "\n"

      if what == 'week'
        matches = dataset.weeks_matches( week_start, week_end )
        if matches.empty?
          puts (' '*4) + "** No matches scheduled or played in week #{week_start.cweek}.\n"
        end
     elsif what == 'yesterday'
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
