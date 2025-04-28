module Footty


  class Dataset


    def matches
       raise ArgumentError, "method matches must be implemented by concrete class!!"
    end

    def league_name
      raise ArgumentError, "method league_name must be implemented by concrete class!!"
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


    def query( q )
        ## query/check for team name match for now
        rx =  /#{Regexp.escape(q)}/i   ## use case-insensitive regex match
        
        matches = select_matches do |match|
                          if rx.match( match['team1'] ) ||
                             rx.match( match['team2'] )  
                             true
                          else
                             false
                          end
                  end
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
  end # class Dataset
end # module Footty
