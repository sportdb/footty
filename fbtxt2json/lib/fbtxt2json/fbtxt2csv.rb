
module Fbtxt2csv


def self.main( args=ARGV )



opts = {  debug:  false,
          output: nil,
          seasons: [],
       }

parser = OptionParser.new do |parser|
parser.banner = "Usage: #{$PROGRAM_NAME} [options] PATH"

##
## check if git has a offline option?? (use same)
##             check for other tools - why? why not?
#    parser.on( "-q", "--quiet",
#                 "less debug output/messages - default is (#{!opts[:debug]})" ) do |debug|
#      opts[:debug] = false
#    end

   parser.on( "--verbose", "--debug",
               "turn on verbose / debug output (default: #{opts[:debug]})" ) do |debug|
     opts[:debug] = true
   end

   parser.on( "-o PATH", "--output PATH",
                  "output to file" ) do |output|
     opts[:output] = output
   end

   parser.on( "--seasons SEASONS",
                  "turn on processing only seasons (default: #{!opts[:seasons].empty?})" ) do |seasons|
       pp seasons
       seasons = seasons.split( /[, ]/ )
       seasons = seasons.map {|season| Season.parse(season) }
       opts[:seasons] = seasons
   end
end
parser.parse!( args )


puts "OPTS:"
p opts
puts "ARGV:"
p args



paths = if args.empty?
          ['/sports/openfootball/euro/2021--europe/euro.txt']
        else
          args
        end


if opts[:debug]
   SportDb::QuickMatchReader.debug = true
   SportDb::MatchParser.debug      = true
else
   SportDb::QuickMatchReader.debug = false
   SportDb::MatchParser.debug      = false
   LogUtils::Logger.root.level = :info
end



recs = []

paths.each do |path|
   if Dir.exist?( path )
      puts "==> reading dir >#{path}<..."

      datafiles = SportDb::Pathspec._find( path, seasons: opts[:seasons] )
      pp datafiles
      puts "   #{datafiles.size} datafile(s)"
      datafiles.each_with_index do |datafile,j|
         puts "    reading file [#{j+1}/#{datafiles.size}] >#{datafile}<..."
         txt = read_text( datafile )
         recs += parse( txt )
      end
   elsif File.exist?( path )
      puts "==> reading file >#{path}<..."
      txt = read_text( path )
      recs += parse( txt )
   else ## not a file or dir report error
       raise ArgumentError, "file/dir does NOT exist - #{path}"
   end
end


recs, headers = vacuum( recs )
pp recs[0,10]   ## dump first 10 records
pp headers
puts "  #{recs.size} record(s)"


if opts[:output]
   puts "==> writing matches to #{opts[:output]}"
   write_csv( opts[:output], recs,
              headers: headers )
end


puts "bye"
end  # self.main




MAX_HEADERS = [
  'League',
  'Date',
  'Time',
  'Team 1',
  'Team 2',
  'Score',      ## generic score - do NOT know if FT/ET or such
  'HT',
  'FT',
  'ET',
  'P',
  'Round',
  'Status',
]


MIN_HEADERS = [   ## always keep even if all empty
  'League',
  'Date',
  'Team 1',
  'Team 2'
]



def self.vacuum( rows, headers: MAX_HEADERS, fixed_headers: MIN_HEADERS )
  ## check for unused columns and strip/remove
  counter = Array.new( MAX_HEADERS.size, 0 )
  rows.each do |row|
     row.each_with_index do |col, idx|
       counter[idx] += 1  unless col.nil? || col.empty?
     end
  end

  ## pp counter

  ## check empty columns
  headers       = []
  indices       = []
  empty_headers = []
  empty_indices = []

  counter.each_with_index do |num, idx|
     header = MAX_HEADERS[ idx ]
     if num > 0 || (num == 0 && fixed_headers.include?( header ))
       headers << header
       indices << idx
     else
       empty_headers << header
       empty_indices << idx
     end
  end

  if empty_indices.size > 0
    rows = rows.map do |row|
             row_vacuumed = []
             row.each_with_index do |col, idx|
               ## todo/fix: use values or such??
               row_vacuumed << col   unless empty_indices.include?( idx )
             end
             row_vacuumed
         end
    end

  [rows, headers]
end



def self.parse( txt )   ### check - name parse_txt or txt_to_csv or such - why? why not?
   quick = SportDb::QuickMatchReader.new( txt )
   matches = quick.parse
   name    = quick.league_name   ## quick hack - get league+season via league_name

   recs = []


   matches.each do |match|

      ## for separator use comma (,) or pipe (|) or ???
      round = String.new
      round << "#{match.group}, "    if match.group
      round << match.round

      ## pp match
      ## pp match.status
      ## pp match.round
      ## pp match.score
      ## pp match.score

      rec = [
            #############################
            ## todo/fix - split league into league_name and season!!!!
            ###############################
            name,  ## league name
            match.date ? match.date : '',
            match.time ? match.time : '',
            match.team1,
            match.team2,
            match.score && match.score.is_a?( Array ) && match.score.size == 2 ?  "#{match.score[0]}-#{match.score[1]}" : '',
            match.score && match.score.is_a?( Hash ) && match.score['ht'] ?  "#{match.score['ht'][0]}-#{match.score['ht'][1]}" : '',
            match.score && match.score.is_a?( Hash ) && match.score['ft'] ?  "#{match.score['ft'][0]}-#{match.score['ft'][1]}" : '',
            match.score && match.score.is_a?( Hash ) && match.score['et'] ?  "#{match.score['et'][0]}-#{match.score['et'][1]}" : '',
            match.score && match.score.is_a?( Hash ) && match.score['p']  ?  "#{match.score['p'][0]}-#{match.score['p'][1]}" : '',
            round,
            match.status ? match.status : '',
       ]

       ## add more attributes e.g. ground, etc.

       recs << rec
   end

   puts "  #{recs.size} record(s)"

   if quick.errors?
      puts "!! #{quick.errors.size} parse error(s):"
      pp quick.errors
      exit 1
   end

   recs
end   # self.parse

end # module Fbtxt2csv