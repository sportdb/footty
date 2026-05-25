
module Footty


  def self.week_tue_to_mon( today=Date.today )
    ## Calculate the start of the (sport) week (tuesday)
    ##  note - wday starts counting sunday (0), monday (1), etc.
    week_tue = today - (today.wday - 2) % 7
    week_mon = week_tue + 6

    [week_tue,week_mon]
  end


  def self.fmt_week( week_start, week_end )
    buf = String.new
    buf << "Week %02d" % week_start.cweek
    buf << " - #{week_start.strftime( "%a %b %-d")}"
    buf << " to #{week_end.strftime( "%a %b %-d %Y")}"
    buf
  end


end # module Footty