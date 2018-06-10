# encoding: utf-8

module Footty

  class Client

    include LogUtils::Logging

    API_BASE = 'https://raw.githubusercontent.com/openfootball/world-cup.json/master/2018'

    def initialize( opts={} )
      @opts   = opts
      @worker = Fetcher::Worker.new
    end



    ### note:
    ##   cache ALL methods - only do one web request for worldcup match schedule & results
    def get_worldcup
      @worldcup ||= get( 'worldcup.json' )    ## use "memoized" / cached result
    end





    ## for testing lets you use /round/1 etc.
    def get_round( num )
      h = get_worldcup
      matches = h[ 'rounds' ][ num-1 ]    ## note: rounds hash starts with zero (not 1)
      matches
    end


    def get_todays_matches( date: Date.today )      get_matches_for( date ); end
    def get_tomorrows_matches( date: Date.today )   get_matches_for( date+1 );  end
    def get_yesterdays_matches( date: Date.today )  get_matches_for( date-1 );  end

    def get_matches_for( date )
      hash  = get_worldcup
      matches = select_matches( hash[ 'rounds' ] ) { |match| date == Date.parse( match['date'] ) }
      matches
    end


    def get_upcoming_matches( date: Date.today )
      ## note: includes todays matches for now
      hash  = get_worldcup
      matches = select_matches( hash[ 'rounds' ] ) { |match| date <= Date.parse( match['date'] ) }
      matches
    end

    def get_past_matches( date: Date.today )
      hash  = get_worldcup
      matches = select_matches( hash[ 'rounds' ] ) { |match| date > Date.parse( match['date'] ) }
      ## note reveserve matches (chronological order/last first)
      matches.reverse
    end

private

    def select_matches( rounds )
      matches = []
      rounds.each do |round|
        round['matches'].each do |match|
          if yield( match )
            ## hack: add (outer) round to match
            match['round'] = round['name']
            matches << match
          else
            ## puts " skipping game   play_date #{play_date}"
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
