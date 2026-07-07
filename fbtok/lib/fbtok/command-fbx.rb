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

  Fbtxt::Lexer.debug = true
  Fbtxt::Parser.debug = true
  Fbtxt::Document.debug = true
else
  ## note - assume no debug is default
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
    doc = Fbtxt::Document.new( txt, start: nil )


      puts ">>> #{doc.teams.size} teams:"
      pp doc.teams
      puts ">>> #{doc.matches.size} matches:"
      pp doc.matches[0,2]   ## print first two matches
      puts "..."
      puts ">>> #{doc.rounds.size} rounds:"
      pp doc.rounds
      puts ">>> #{doc.groups.size} groups:"
      pp doc.groups
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
