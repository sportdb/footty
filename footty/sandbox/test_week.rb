####
#  to run use:
#    $  ruby sandbox/test_week.rb


$LOAD_PATH.unshift( './lib' )
require 'footty'


today = Date.today
pp today


pp Footty.week_tue_to_mon
pp Footty.week_tue_to_mon( today)
pp Footty.week_tue_to_mon( today+1)
pp Footty.week_tue_to_mon( today+2)
pp Footty.week_tue_to_mon( today+3)
pp Footty.week_tue_to_mon( today+4)
pp Footty.week_tue_to_mon( today+5)
pp Footty.week_tue_to_mon( today+6)
pp Footty.week_tue_to_mon( today+7)
pp Footty.week_tue_to_mon( today+8)
pp Footty.week_tue_to_mon( today+9)
pp Footty.week_tue_to_mon( today+10)
pp Footty.week_tue_to_mon( today+11)
pp Footty.week_tue_to_mon( today+12)
pp Footty.week_tue_to_mon( today+13)

week_start, week_end = Footty.week_tue_to_mon( today)
puts  Footty.fmt_week( week_start, week_end )


puts  Footty.fmt_week(*Footty.week_tue_to_mon( today+7) )
puts  Footty.fmt_week(*Footty.week_tue_to_mon( today+13) )
puts  Footty.fmt_week(*Footty.week_tue_to_mon( Date.new( 2024, 12, 31)) )
puts  Footty.fmt_week(*Footty.week_tue_to_mon( Date.new( 2026, 1, 1)) )


puts "bye"