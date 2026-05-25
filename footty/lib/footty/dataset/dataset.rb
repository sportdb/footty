module Footty


##
#    note - assume "upstream" date is always date object or nil (NOT string)!!!

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
                           end_date = match['date']   if end_date.nil? || match['date'] > end_date
                        end
                        end_date
                     end
    end

    def start_date
       @start_date ||= begin
                        start_date = nil
                        matches.each do |match|
                           start_date = date = match['date']  if start_date.nil? || date = match['date'] < start_date
                        end
                        start_date
                       end
    end


    def todays_matches(     date: Date.today )  _select_matches { |match| date   == match['date'] };  end
    def tomorrows_matches(  date: Date.today )  _select_matches { |match| date+1 == match['date'] };  end
    def yesterdays_matches( date: Date.today )  _select_matches { |match| date-1 == match['date'] };  end


    def weeks_matches( start_week, end_week )
      _select_matches do |match|
                                 match['date'] >= start_week && match['date'] <= end_week
                       end
    end


    def upcoming_matches( date: Date.today,
                          limit: nil )
      ## note: includes todays matches for now
      matches = _select_matches { |match| date <= match['date'] }

      if limit
        matches[0, limit]  ## cut-off
      else
        matches
      end
    end


    def past_matches( date: Date.today )
      matches = _select_matches { |match| date > match['date'] }
      ## note reveserve matches (chronological order/last first)
      ## matches.reverse
      matches
    end



    def query( q )
        ## query/check for team name match for now
        rx =  /#{Regexp.escape(q)}/i   ## use case-insensitive regex match

        _select_matches do |match|
                          if rx.match( match['team1'] ) ||
                             rx.match( match['team2'] )
                             true
                          else
                             false
                          end
                        end
    end




    def _select_matches( &blk )
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
