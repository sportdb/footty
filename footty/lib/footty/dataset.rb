module Footty


  class Dataset
    SOURCES = {
      'world' => { '2022' => [ 'worldcup/2022--qatar/cup.txt',
                               'worldcup/2022--qatar/cup_finals.txt'],
                   '2018' => [ 'worldcup/2018--russia/cup.txt',
                               'worldcup/2018--russia/cup_finals.txt']
                 },
      'euro' =>  { '2024' => 'euro/2024--germany/euro.txt',
                   '2021' => 'euro/2021--europe/euro.txt'
                 },
      'de'  =>    'deutschland/$season$/1-bundesliga.txt',
      'de2' =>   'deutschland/$season$/2-bundesliga2.txt',
      'en'=>    'england/$season$/1-premierleague.txt',
      'es'=>    'espana/$season$/1-liga.txt',
      'it'=>    'italy/$season$/1-seriea.txt',
      'at'=>    'austria/$season$/1-bundesliga.txt',
      'at2'  =>   'austria/$season$/2-liga2.txt',
      'at3o' =>   'austria/$season$/3-regionalliga-ost.txt',
      'atcup' =>  'austria/$season$/cup.txt',

      'fr'=>    'europe/france/$season$/1-ligue1.txt',
      'nl'=>    'europe/netherlands/$season$/1-eredivisie.txt',
      'be'=>    'europe/belgium/$season$/1-firstdivisiona.txt',

      'champs'=> 'champions-league/$season$/cl.txt',

      'br'    => 'south-america/brazil/$year$/1-seriea.txt',
      'ar'    => 'south-america/argentina/$year$/1-primeradivision.txt',
      'co'    => 'south-america/colombia/$year$/1-primeraa.txt',
      ## use a different code for copa libertadores? why? why not?
      'copa'  => 'south-america/copa-libertadores/$year$/libertadores.txt',

      'mx'    => 'mexico/$season$/1-ligamx.txt',

      'eg'    => 'africa/egypt/$season$/1-premiership.txt',
      'ma'    => 'africa/morocco/$season$/1-botolapro1.txt',
    }


    ## return built-in league keys
    def self.leagues()  SOURCES.keys; end


    def initialize( league:,  year: nil )
      @league = league

      spec = SOURCES[ @league.downcase ]
      urls = if spec.is_a?( Hash )  ## assume lookup by year
                if year.nil?  ## lookup default first entry
                     year = spec.keys[0].to_i
                     spec.values[0]
                else
                     spec[ year.to_s ]
                end
              else  ## assume vanilla urls (no lookup by year)
                   ## default to 2024 for now
                   year = 2024  if year.nil?
                   spec
              end
      raise ArgumentError, "no dataset (source) for league #{league} found"    if urls.nil?

      ## wrap single sources (strings) in array
      urls = urls.is_a?( Array ) ? urls : [urls]
      ## expand shortened url and fill-in template vars
      @urls = urls.map { |url| openfootball_url( url, year: year ) }
    end


    def openfootball_url( path, year: )
       repo, local_path = path.split( '/',  2)
       url = "https://raw.githubusercontent.com/openfootball/#{repo}/master/#{local_path}"
       ## check for template vars too
       season = Season( "#{year}/#{year+1}" )
       url = url.gsub( '$year$', year.to_s )
       url = url.gsub( '$season$', season.to_path )
       url
    end


    ### note:
    ##   cache ALL methods - only do one web request for match schedule & results
    def matches
      @data ||= begin
                  matches = []
                  @urls.each do |url|
                    txt = get!( url )    ## use "memoized" / cached result
                    matches += SportDb::QuickMatchReader.parse( txt )
                  end
                  data = matches.map {|match| match.as_json }  # convert to json
                  ## quick hack to get keys as strings not symbols!!
                  ##  fix upstream
                  JSON.parse( JSON.generate( data ))
                end
    end


    def end_date
       @end_date ||= begin
                        end_date = nil
                        matches.each do |match|
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
                        matches.each do |match|
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
      ## matches.reverse
      matches
    end


private
    def select_matches( &blk)
      selected = []
      matches.each do |match|
         selected << match   if blk.call( match )
      end

      ## todo/fix:
      ##  sort matches here; might not be chronologicial (by default)
      selected
    end  # method select_matches



    def get!( url )
        ##  use cached urls for 12h by default
        ##  if expired in cache (or not present) than get/fetch
       if Webcache.expired_in_12h?( url )
         response = Webget.text( url )

         if response.status.ok?
           response.text   # note - return text (utf-8)
         else
           ## dump headers
           response.headers.each do |key,value|
             puts "   #{key}:  #{value}"
           end
           puts "!! HTTP ERROR - #{response.status.code} #{response.status.message}"
           exit 1
         end
       else
         Webcache.read( url )
       end
    end  # method get_txt!
  end # class Dataset
end # module Footty
