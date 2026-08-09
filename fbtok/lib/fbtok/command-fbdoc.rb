
##
## read textfile
##   and dump match parse results
##
##  note - for now works (on purpose) with only ONE textfile/matchfile/datafile
##
##   $ fbdoc worldcup_2022_final.txt
##   $ fbdoc 2022full.txt
##   $ fbdoc austria/2025-26/1-bundesliga-full.txt

##
##  todos
##   - [ ] check/add auto-formation in (upstream) document
##   - [ ]  use a struct for lineup (w/  starter/bench/subs - replace hash!!!)
##   - [ ]  json dump (change minute to "plain", that is, do NOT use/add minute quote
##                     e.g. "23'"    => "23",
##                          "120'+1" => "120+1" )

=begin
  worldcup 1930
  --  do NOT add empty bench or subs - why? why not?
     {"name"=>"Guillermo STABILE"}],
     "bench"=>[],
     "subs"=>[]}],
  -- do NOT add bookings if both empty!!!
  "bookings"=>[[], []],
=end



module Fbdoc

def self.main( args=ARGV )

 opts = { debug: false,
          json:  false,
          none:  false }

 parser = OptionParser.new do |parser|
  parser.banner = "Usage: #{$PROGRAM_NAME} [options] DATAFILE"


  parser.on( "--verbose", "--debug",
               "turn on verbose / debug output (default: #{opts[:debug]})" ) do |debug|
    opts[:debug] = true
  end

  parser.on( "-j", "--json",
                "turn on output in json (default: #{opts[:json]})" ) do |json|
    opts[:json] = true
  end

  parser.on( "--none",
                "turn off output (default: #{opts[:json]})" ) do |none|
    opts[:none] = true
  end

end
parser.parse!( args )


if opts[:debug]
  puts "OPTS:"
  p opts
  puts "ARGV:"
  p args

  Fbtxt::Lexer.debug = true
  Fbtxt::Parser.debug = true
  Fbtxt::Document.debug = true
else
  ## note - assume no debug is default
end



if args.empty?
    puts "!! error - no args; NAME required - sorry"
    exit 1
end



## preconfigured lookup path
path = ['/sports/sportdb/sport.db.v2/document/samples',
        '/sports/sportdb/sport.db.v2/parser/fbtxt-specs',
        '/sports/sportdb/sport.db.v2/parser/fbtxt-samples',
        '/sports/openfootball',
        '/sports/openfootball/worldcup/more']

name    = args[0]
fullpath = find_file!( name, path: path )

    puts "==> reading >#{fullpath}<..."

    doc = Fbtxt::Document.read( fullpath )



    if opts[:json]
      puts
      puts "  try json for matches:"
      data = doc.matches.map {|match| match.as_json }
      pp data

      puts "---"
      puts " - #{doc.teams.size} team(s)"
      puts " - #{doc.matches.size} match(es)"
      puts " - #{doc.rounds.size} round(s)"
      puts " - #{doc.groups.size} group(s)"
    elsif opts[:none]
      puts "---"
      puts " - #{doc.teams.size} team(s)"
      puts " - #{doc.matches.size} match(es)"
      puts " - #{doc.rounds.size} round(s)"
      puts " - #{doc.groups.size} group(s)"
    else
      pp doc
      puts

      puts ">>> #{doc.teams.size} teams:"
      pp doc.teams
      puts ">>> #{doc.matches.size} matches:"
      pp doc.matches[0,2]   ## print first two matches
      puts "..."
      puts ">>> #{doc.rounds.size} rounds:"
      pp doc.rounds
      puts ">>> #{doc.groups.size} groups:"
      pp doc.groups
   end

###
##  note - always report errors


if doc.errors?
    puts
    pp doc.errors
    puts
    puts "!!   #{doc.errors.size} parse error(s)"
else
    puts
    puts "OK   no parse errors found (in #{fullpath})"
end


puts "bye"

end  # self.main
end  # module Fbdoc
