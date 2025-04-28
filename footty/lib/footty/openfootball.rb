module Footty


  class OpenfootballDataset  <  Dataset
    SOURCES = {
      'world' => { '2022' => [ 'worldcup/2022--qatar/cup.txt',
                               'worldcup/2022--qatar/cup_finals.txt'],
                   '2018' => [ 'worldcup/2018--russia/cup.txt',
                               'worldcup/2018--russia/cup_finals.txt']
                 },
      'euro' =>  { '2024' => 'euro/2024--germany/euro.txt',
                   '2021' => 'euro/2021--europe/euro.txt'
                 },
      'de'    =>    'deutschland/$season$/1-bundesliga.txt',
      'de2'   =>   'deutschland/$season$/2-bundesliga2.txt',
      'de3'   =>   'deutschland/$season$/3-liga3.txt',
      'decup' =>   'deutschland/$season$/cup.txt',
      

      'en'   =>    'england/$season$/1-premierleague.txt',
      'en2'  =>    'england/$season$/2-championship.txt',
      ##  add alternate codes!!!
      ##   use  eflcup, facup - why? why not?
      'eneflcup'  =>  'england/$season$/eflcup.txt',
      'enfacup'   =>  'england/$season$/facup.txt',
    

      'es'    =>  'espana/$season$/1-liga.txt',
      'escup' =>  'espana/$season$/cup.txt',

      'it'=>    'italy/$season$/1-seriea.txt',
   
      'at'=>    'austria/$season$/1-bundesliga.txt',
      'at2'  =>   'austria/$season$/2-liga2.txt',
      'at3o' =>   'austria/$season$/3-regionalliga-ost.txt',
      'atcup' =>  'austria/$season$/cup.txt',

      'fr'=>    'europe/france/$season$_fr1.txt',
      'nl'=>    'europe/netherlands/$season$_nl1.txt',
      'be'=>    'europe/belgium/$season$_be1.txt',

      'champs'=> 'champions-league/$season$/cl.txt',

      'br'    => 'south-america/brazil/$year$_br1.txt',
      'ar'    => 'south-america/argentina/$year$_ar1.txt',
      'co'    => 'south-america/colombia/$year$_co1.txt',
      
      ## use a different code for copa libertadores? why? why not?
      'copa'  => 'south-america/copa-libertadores/$year$_copal.txt',

      'mx'    => 'world/north-america/mexico/$season$_mx1.txt',
      'mls'   => 'world/north-america/major-league-soccer/$year$_mls.txt',

      'eg'    => 'world/africa/egypt/$season$_eg1.txt',
      'ma'    => 'world/africa/morocco/$season$_ma1.txt',

      'au'    =>  'world/pacific/australia/$season$_au1.txt',
      'jp'    =>  'world/asia/japan/$year$_jp1.txt',
      'cn'    =>  'world/asia/china/$year$_cn1.txt',

    }


    ## return built-in league keys
    def self.leagues()  SOURCES.keys; end



    ### auto-fill latest season
    def self.latest_season( league: )
      spec = SOURCES[ league.downcase ]

      raise ArgumentError, "no dataset (source) for league #{league} found"    if spec.nil?

      ##  todo/fix - report error if no spec found
      season =  if spec.is_a?( Hash )  ## assume lookup by year
                    spec.keys[0]   
                else  ## assume vanilla urls (no lookup by year)
                    ## default to 2025 or 2024/25 for now
                    spec.index( '$year$') ? '2025' : '2024/25'
                end
      season
    end



    def initialize( league:, season: )
      spec = SOURCES[ league.downcase ]

      urls = if spec.is_a?( Hash )  ## assume lookup by year
                spec[ season ]
              else  ## assume vanilla urls (no lookup by year)
                spec
              end
      raise ArgumentError, "no dataset (source) for league #{league} found"    if urls.nil?

      ## wrap single sources (strings) in array
      urls = urls.is_a?( Array ) ? urls : [urls]
      ## expand shortened url and fill-in template vars
      urls = urls.map { |url| openfootball_url( url, season: season ) }

      matches = []
      urls.each do |url|
                    txt = get!( url )    ## use "memoized" / cached result
                    parser = SportDb::QuickMatchReader.new( txt )
                    matches += parser.parse
                    ###  for multiple source file use latest name as "definitive"
                    @league_name = parser.league_name
                    ###  todo/fix - report errors
                  end

      matches = matches.map {|match| match.as_json }  # convert to json
             
      ## note - sort by date/time 
      ##  (assume stable sort; no reshuffle of matches if already sorted by date/time)

      matches = matches.sort do |l,r|
                     result =  l['date'] <=> r['date']
                     result =  l['time'] <=> r['time']    if result == 0 && 
                                                           (l['time'] && r['time'])
                     result
                  end

      @matches = matches
    end


    def openfootball_url( path, season: )
       repo, local_path = path.split( '/',  2)
       url = "https://raw.githubusercontent.com/openfootball/#{repo}/master/#{local_path}"
       ## check for template vars too
       season = Season( season )
       url = url.gsub( '$year$', season.start_year.to_s )
       url = url.gsub( '$season$', season.to_path )
       url
    end


    def matches()     @matches; end
    def league_name() @league_name; end
  


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

end  # class OpenfootballDaset
end  # module Footty