# encoding: utf-8

module Ojogo

  class Client

    include LogUtils::Logging

    API_BASE = 'http://footballdb.herokuapp.com/api/v1'

    def initialize( opts={} )
      @opts   = opts
      @worker = Fetcher::Worker.new
    end


    def get_todays_round
      event_key = 'world.2014'
      get( "event/#{event_key}/round/today" )
    end

    ## for testing lets you use /round/1 etc.
    def get_round( num )
      event_key = 'world.2014'
      get( "event/#{event_key}/round/#{num}" )
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


end # module Ojogo
