# encoding: utf-8

module Footty

  class Client

    include LogUtils::Logging

    API_BASE = 'https://raw.githubusercontent.com/openfootball/world-cup.json/master/2018'

    def initialize( opts={} )
      @opts   = opts
      @worker = Fetcher::Worker.new
    end



    ### todo/fix:
    ##   cache ALL method - only do one request!!!!
    ##   use get_schedule  or get_matches ??
    ##   use get_worldcup !!!!!!

    def get_worldcup
      @worldcup ||= get( 'worldcup.json' )    ## use "memoized" / cached result
    end




    ## for testing lets you use /round/1 etc.
    def get_round( num )
      h = get_worldcup
      matches = h[ 'rounds' ][ num-1 ]    ## note: rounds hash starts with zero (not 1)
      matches
    end


    ### todo/fix:
    ##  add a new services for todays games only (not todays round w/ all games)
    def get_todays_matches
      hash = get_worldcup
      matches = select_todays_matches( hash[ 'rounds' ] )
      matches
    end

private

   ## todo/fix:
   ##   use julian date??
   ##   sort by date
   ##   - past games (yesterday, etc.)
   ##   - todays games
   ##   - future games (tomorrow, etc.)

    def select_todays_matches( rounds )
      matches = []
      rounds.each do |round|
        round['matches'].each do |match|
          date = Date.parse( match['date'] )
          if play_at == Date.today
            matches << match
          else
            ## puts " skipping game   play_at #{play_at}"
          end
        end
      end
      matches
    end

    def get( path )
      ## uri = URI.parse( "#{API_BASE}/#{path}" )
      # fix: use is_a? URI in fetcher
      uri_string = "#{API_BASE}/#{path}"

      response = @worker.get_response( uri_string )

      if response.code == '200'
        ##
        ## todo/check:
        ##  do we need to force utf-8 encoding?
        ##   check for teams w/ non-ascii names
        hash = JSON.parse( response.body )
        ## pp hash
        hash
      else
        logger.error "fetch HTTP - #{response.code} #{response.message}"
        nil
      end
    end

  end # class Client


end # module Footty
