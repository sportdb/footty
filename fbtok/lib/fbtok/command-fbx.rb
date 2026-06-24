##
## todo/fix - use for testing
#                reads textfile and dumps results in json
#
#  check - keep fbx name or find a differnt name - why? why not?

##
## read textfile
##   and dump match parse results
##
##   fbt  ../openfootball/.../euro.txt



module Fbx

def self.main( args=ARGV )

 opts = { debug: false,
          outline: false }

 parser = OptionParser.new do |parser|
  parser.banner = "Usage: #{$PROGRAM_NAME} [options] DATAFILE"

##
## check if git has a offline option?? (use same)
##             check for other tools - why? why not?


  parser.on( "--verbose", "--debug",
               "turn on verbose / debug output (default: #{opts[:debug]})" ) do |debug|
    opts[:debug] = debug
  end

#  parser.on( "--outline",
#                "turn on outline (only) output (default: #{opts[:outline]})" ) do |outline|
#    opts[:outline] = outline
#  end
end
parser.parse!( args )


if opts[:debug]
  puts "OPTS:"
  p opts
  puts "ARGV:"
  p args

  SportDb::Lexer.debug = true
  RaccMatchParser.debug = true
  SportDb::MatchParser.debug = true
else
  SportDb::MatchParser.debug = false
  LogUtils::Logger.root.level = :info
end


args =  [
              '/sports/openfootball/euro/2021--europe/euro.txt',
              '/sports/openfootball/euro/2024--germany/euro.txt',
        ]   if args.empty?

pp args



## errors = []


paths = args

paths.each_with_index do |path,i|
    puts "==> [#{i+1}/#{paths.size}] reading >#{path}<..."

    txt = read_text( path )

    ##
    ## note - use start: nil => requires that first date incl. a year!!!
    parser = SportDb::MatchParser.new( txt, start: nil )

    auto_conf_teams, matches, rounds, groups = parser.parse

      puts ">>> #{auto_conf_teams.size} teams:"
      pp auto_conf_teams
      puts ">>> #{matches.size} matches:"
      pp matches[0,2]   ## print first two matches
      puts "..."
      puts ">>> #{rounds.size} rounds:"
      pp rounds
      puts ">>> #{groups.size} groups:"
      pp groups
end  # each paths

=begin
if errors.size > 0
    puts
    pp errors
    puts
    puts "!!   #{errors.size} parse error(s) in #{paths.size} datafiles(s)"
else
    puts
    puts "OK   no parse errors found in #{paths.size} datafile(s)"
end
=end

puts "bye"

end  # self.main
end  # module Fbx
