
module Ojogo

  class Client

    API_BASE = 'http://footballdb.herokuapp.com/api/v1'

    def initialize( opts={} )
      @opts = opts
    end

    def get_todays_round
      event_key = "world.2014"

      uri = URI.parse( "#{API_BASE}/event/#{event_key}/round/today" )

      http = Net::HTTP.new( uri.host, uri.port )
      response = http.request( Net::HTTP::Get.new( uri.request_uri ))
      
      if response.code == '200'
        hash = JSON.parse( response.body )
        ## pp hash
        hash
      else
        nil
      end
    end
    
    ### todo/fix:
    ##  add a new services for todays games only (not todays round w/ all games)
    def get_todays_games
      round_hash = get_todays_round()
      games = select_todays_games( round_hash[ 'games' ] )
      games
    end

    def select_todays_games( all_games )
      games = []
      all_games.each do |game|
        play_at = Date.parse( game['play_at'] )
        if play_at == Date.today
          games << game
        else
          ## puts " skipping game   play_at #{play_at}"
        end
      end
      games
    end

  end # class Client


end # module Ojogo
