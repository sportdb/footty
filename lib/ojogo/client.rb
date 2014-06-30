
module Ojogo

  class Client

    include LogUtils::Logging

    API_BASE = 'http://footballdb.herokuapp.com/api/v1'

    def initialize( opts={} )
      @opts = opts
    end


    def get_todays_round
      event_key = "world.2014"
      get( "event/#{event_key}/round/today" )
    end

    ### todo/fix:
    ##  add a new services for todays games only (not todays round w/ all games)
    def get_todays_games
      round_hash = get_todays_round()
      games = select_todays_games( round_hash[ 'games' ] )
      games
    end

private
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

    def get( path )
      uri = URI.parse( "#{API_BASE}/#{path}" )

      # new code: honor proxy env variable HTTP_PROXY
      proxy = ENV['HTTP_PROXY']
      proxy = ENV['http_proxy'] if proxy.nil?   # try possible lower/case env variable (for *nix systems) is this necessary??
    
      if proxy
        proxy = URI.parse( proxy )
        logger.debug "using net http proxy: proxy.host=#{proxy.host}, proxy.port=#{proxy.port}"
        if proxy.user && proxy.password
          logger.debug "  using credentials: proxy.user=#{proxy.user}, proxy.password=****"
        else
          logger.debug "  using no credentials"
        end
      else
        logger.debug "using direct net http access; no proxy configured"
        proxy = OpenStruct.new   # all fields return nil (e.g. proxy.host, etc.)
      end

      http_proxy = Net::HTTP::Proxy( proxy.host, proxy.port, proxy.user, proxy.password )

      http = http_proxy.new( uri.host, uri.port )
      response = http.request( Net::HTTP::Get.new( uri.request_uri ))

      if response.code == '200'
        hash = JSON.parse( response.body )
        ## pp hash
        hash
      else
        logger.error "fetch HTTP - #{response.code} #{response.message}"
        nil
      end
    end

  end # class Client


end # module Ojogo
