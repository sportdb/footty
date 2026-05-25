
module Footty


##
#    note - assume "upstream" date is always date object or nil (NOT string)!!!

 def self.print_matches( matches )

    today = Date.today

    last_date  = nil
    last_round = nil

    matches.each do |match|

      ## note - merge group into round

      round = String.new
      round += "#{match['group']}, "   if match['group']     ## (optional) group
      round += "#{match['round']}"

      if last_round.nil? || last_round != round
        print "▪ #{round} ▪\n"    ## knock out (k.o.) phase/stage
        last_date = nil
      else
        ## print "     " + (" " *round.length)
      end
      last_round = round





      date = match['date']

      ## do NOT repeat same date
      if last_date.nil? || last_date != date
        print "#{date.strftime('%a %b %d')} "      ## e.g. Thu Jun 14
      else
        print "           "
      end
      last_date = date


      print "#{match['time']} "    if match['time']

      if date > today
         diff = (date - today).to_i
         print "%10s" % "(in #{diff}d) "
      end


      if match['team1'].is_a?( Hash )
        print "%22s" % "#{match['team1']['name']} (#{match['team1']['code']})"
      else
        print "%22s" % "#{match['team1']}"
      end



      if match['score'].is_a?( Hash )

          if match['score']['et']
             et = "#{match['score']['et'][0]}-#{match['score']['et'][1]} aet"
             print "  #{et}"
          end

          if match['score']['ft']
             ft = "#{match['score']['ft'][0]}-#{match['score']['ft'][1]}"
             if match['score']['et']
                print " (#{ft})"
             else
                print "  #{ft}"
             end
          end

          if match['score']['p']
            pen = "#{match['score']['p'][0]}-#{match['score']['p'][1]} pen"
            print ", #{pen}"
          end
          print "  "

      elsif match['score'] &&
            match['score'][0] && match['score'][1]
        score = "#{match['score'][0]}-#{match['score'][1]}"
        print "  #{score}  "
      else
        print "   v   "
      end

      if match['team2'].is_a?( Hash )
        print "%-22s" % "#{match['team2']['name']} (#{match['team2']['code']})"
      else
        print "%-22s" % "#{match['team2']}"
      end



      print "%-5s " % "(\##{match['num']}) "   if match['num']

      print " @ #{match['ground']}"         if match['ground']


      print " [#{match['status']}]"   if match['status']


      print "\n"


      if match['goals1'] && match['goals2']
        print "                     ("

        print _pp_goals(match['goals1'])   if match['goals1'].size > 0

        print "; "   if match['goals1'].size > 0 &&
                        match['goals2'].size > 0

        print _pp_goals(match['goals2'])   if match['goals2'].size > 0

        print ")\n"
      end
    end
  end



def self._pp_goals( recs )
   players = {}

   ## "fold" multiple goals of player
   recs.each do |rec|

      name = rec['name']

      if  rec['minute'].nil? || rec['minute'].empty?
        puts "!! WARN - (goals) minute empty:"
        pp rec
        ## use '??'
        rec['minute'] = '??'
        ## raise ArgumentError, "minute empty"
      end

      goal = String.new
      goal << "#{rec['minute']}'"
      goal << '(og)'   if rec['owngoal'] == true
      goal << '(p)'    if rec['penalty'] == true

      player_rec = players[ name ] ||= { name: name, goals: [] }
      player_rec[:goals] << goal
   end


   buf =  players.map do |_,player|
                    "#{player[:name]} #{player[:goals].join(',')}"
                end.join( ' ' )
   buf
end


end # module Footty
