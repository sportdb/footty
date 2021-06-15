module Footty


  class Client

    include LogUtils::Logging


    def initialize( league:, year: )
      @worker = Fetcher::Worker.new

      @league = league
      @year   = year
    end


    APIS = {
      worldcup: 'https://github.com/openfootball/worldcup.json/raw/master/$year$/worldcup.json',
      euro:     'https://github.com/openfootball/euro.json/raw/master/$year$/euro.json'
    }

    ### note:
    ##   cache ALL methods - only do one web request for match schedule & results
    def get_matches
      @data ||= begin
                  str = APIS[ @league.downcase.to_sym ]
                  str = str.gsub( '$year$', @year.to_s )

                  get( str )    ## use "memoized" / cached result
                end
    end




    ## for testing lets you use /round/1 etc.
    def round( num )
      h = get_matches
      matches = h[ 'rounds' ][ num-1 ]    ## note: rounds hash starts with zero (not 1)
      matches
    end


    def todays_matches( date: Date.today )      matches_for( date ); end
    def tomorrows_matches( date: Date.today )   matches_for( date+1 );  end
    def yesterdays_matches( date: Date.today )  matches_for( date-1 );  end

    def matches_for( date )
      hash  = get_matches
      matches = select_matches( hash[ 'rounds' ] ) { |match| date == Date.parse( match['date'] ) }
      matches
    end


    def upcoming_matches( date: Date.today )
      ## note: includes todays matches for now
      hash  = get_matches
      matches = select_matches( hash[ 'rounds' ] ) { |match| date <= Date.parse( match['date'] ) }
      matches
    end

    def past_matches( date: Date.today )
      hash  = get_matches
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


    def get( str )
      response = @worker.get_response( str )

      if response.code == '200'
        ##
        ## fix/fix/todo/check:
        ##  do we need to force utf-8 encoding? yes!!!!
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
