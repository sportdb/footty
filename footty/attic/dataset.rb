module Footty



  class Dataset

    def initialize( league:, year: )
      @league = league
      @year   = year
      @season = Season( "#{year}/#{year+1}" )
    end


    APIS = {
      world:    'https://raw.githubusercontent.com/openfootball/worldcup.json/master/$year$/worldcup.json',
      euro:     'https://raw.githubusercontent.com/openfootball/euro.json/master/$year$/euro.json',
      de:       'https://raw.githubusercontent.com/openfootball/deutschland/master/$season$/1-bundesliga.txt',
      en:       'https://raw.githubusercontent.com/openfootball/england/master/$season$/1-premierleague.txt',
      at:       'https://raw.githubusercontent.com/openfootball/austria/master/$season$/1-bundesliga-i.txt',
    }

    ### note:
    ##   cache ALL methods - only do one web request for match schedule & results
    def matches
      @data ||= begin
                  url = APIS[ @league.downcase.to_sym ]
                  url = url.gsub( '$year$', @year.to_s )
                  url = url.gsub( '$season$', @season.to_path )

                  res = get!( url )    ## use "memoized" / cached result
                  if url.end_with?( '.json' )
                      JSON.parse( res.text )
                  else  ## assume football.txt format
                      matches = SportDb::QuickMatchReader.parse( res.text )
                      data = matches.map {|match| match.as_json }  # convert to json
                      ## quick hack to get keys as strings not symbols!!
                      ##  fix upstream
                      JSON.parse( JSON.generate( data ))
                  end
                end
    end

    def end_date
       @end_date ||= begin
                        end_date = nil
                        each do |match|
                           date = Date.strptime(match['date'], '%Y-%m-%d' )
                           end_date = date  if end_date.nil? ||
                                               date > end_date
                        end
                        end_date
                     end
    end

    def start_date
       @start_date ||= begin
                        start_date = nil
                        each do |match|
                           date = Date.strptime(match['date'], '%Y-%m-%d' )
                           start_date = date  if start_date.nil? ||
                                               date < start_date
                        end
                        start_date
                       end
    end

    def todays_matches( date: Date.today )      matches_for( date ); end
    def tomorrows_matches( date: Date.today )   matches_for( date+1 );  end
    def yesterdays_matches( date: Date.today )  matches_for( date-1 );  end

    def matches_for( date )
      matches = select_matches { |match| date == Date.parse( match['date'] ) }
      matches
    end


    def upcoming_matches( date: Date.today,
                          limit: nil )
      ## note: includes todays matches for now
      matches = select_matches { |match| date <= Date.parse( match['date'] ) }

      if limit
        matches[0, limit]  ## cut-off
      else
        matches
      end
    end

    def past_matches( date: Date.today )
      matches = select_matches { |match| date > Date.parse( match['date'] ) }
      ## note reveserve matches (chronological order/last first)
      matches.reverse
    end


private
    def each
      data = matches
      if data.is_a?( Hash) && data.has_key?('rounds')
        data['rounds'].each do |round|
          round['matches'].each do |match|
            ## hack: add (outer) round to match
            match['round'] = round['name']
            yield( match )
          end
        end
      else  ## assume flat matches in Array
        data.each do |match|
          yield( match )
        end
      end
    end


    def select_matches
      matches = []
      each do |match|
         matches << match   if yield( match )
      end

      ## todo/fix:
      ##  sort matches here; might not be chronologicial (by default)
      matches
    end  # method select_matches


    def get!( url )
      response = Webclient.get( url )

      if response.status.ok?
         response
      else
        puts "!! HTTP ERROR - #{response.status.code} #{response.status.message}"
        ## dump headers
        response.headers.each do |key,value|
           puts "   #{key}:  #{value}"
        end
        exit 1
      end
    end  # method get!
  end # class Client
end # module Footty
