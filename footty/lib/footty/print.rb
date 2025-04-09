
module Footty

 def self.print_matches( matches )
  
    today = Date.today

    matches.each do |match|
      print "   %5s" % "\##{match['num']} "   if match['num']

      date = Date.strptime( match['date'], '%Y-%m-%d' )
      print "#{date.strftime('%a %b/%d')} "      ## e.g. Thu Jun/14
      print "#{match['time']} "  if match['time']

      if date > today
         diff = (date - today).to_i
         print "%10s" % "(in #{diff}d) "
      end


      if match['team1'].is_a?( Hash )
        print "%22s" % "#{match['team1']['name']} (#{match['team1']['code']})"
      else
        print "%22s" % "#{match['team1']}"
      end


      if match['score'].is_a?( Hash ) &&
         match['score']['ft']
          if match['score']['ft']
             print " #{match['score']['ft'][0]}-#{match['score']['ft'][1]} "
          end
          if match['score']['et']
            print "aet #{match['score']['et'][0]}-#{match['score']['et'][1]} "
          end
          if match['score']['p']
            print "pen #{match['score']['p'][0]}-#{match['score']['p'][1]} "
          end
      elsif match['score1'] && match['score2']
        ## todo/fix: add support for knockout scores
        ##                 with score1et/score1p  (extra time and penalty)
        print " #{match['score1']}-#{match['score2']} "
        print "(#{match['score1i']}-#{match['score2i']}) "
      else
        print "    vs    "
      end

      if match['team2'].is_a?( Hash )
        print "%-22s" % "#{match['team2']['name']} (#{match['team2']['code']})"
      else
        print "%-22s" % "#{match['team2']}"
      end

      if match['stage']
        print " #{match['stage']} /"    ## stage
      end

      if match['group']
        print " #{match['group']} /"    ## group phase
      end

      print " #{match['round']} "    ## knock out (k.o.) phase/stage

      ## todo/fix - check for ground name in use???
      if match['stadium']
        print " @ #{match['stadium']['name']}, #{match['city']}"
      end

      print "\n"


      if match['goals1'] && match['goals2']
        print "                     ["
        match['goals1'].each_with_index do |goal,i|
          print " "    if i > 0
          print "#{goal['name']}"
          print " #{goal['minute']}"
          print "+#{goal['offset']}"   if goal['offset']
          print "'"
          print " (o.g.)"    if goal['owngoal']
          print " (pen.)"    if goal['penalty']
        end
        match['goals2'].each_with_index do |goal,i|
          if i == 0
            print "; "
          else
           print " "
          end
          print "#{goal['name']}"
          print " #{goal['minute']}"
          print "+#{goal['offset']}"  if goal['offset']
          print "'"
          print " (o.g.)"  if goal['owngoal']
          print " (pen.)"  if goal['penalty']
        end
        print "]\n"
      end
    end
  end


end # module Footty
