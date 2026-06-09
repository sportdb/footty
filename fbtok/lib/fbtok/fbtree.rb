
module Fbtree

def self.main( args=ARGV )


opts = {
    debug: true,
    warn:  false,
    file:  nil,
}

parser = OptionParser.new do |parser|
  parser.banner = "Usage: #{$PROGRAM_NAME} [options] DATAFILE or DIR"


  parser.on( "-q", "--quiet",
             "less debug output/messages (default: #{!opts[:debug]})" ) do |debug|
    opts[:debug] = false
  end
  parser.on( "--verbose", "--debug",
               "turn on verbose / debug output (default: #{opts[:debug]})" ) do |debug|
    opts[:debug] = true
  end
  parser.on( "-w", "--warn",
              "turn warnings into errors (default: #{opts[:warn]})" ) do |warn|
    opts[:warn] = true
  end


  parser.on( "-f FILE", "--file FILE",
                "read datafiles (pathspecs) via .csv file") do |file|
    opts[:file] = file
    ## note: for batch (massive) processing auto-set debug (verbose output) to false (as default)
    opts[:debug] = false
  end

end
parser.parse!( args )


if opts[:debug]
  puts "OPTS:"
  p opts
  puts "ARGV:"
  p args
end


# SportDb::Parser::Linter.debug = opts[:debug]
# SportDb::Parser::Linter.warn  = opts[:warn]




## todo/check - use packs or projects or such
##                instead of specs - why? why not?
specs =  if opts[:file]
            read_pathspecs( opts[:file] )
         else
            ## check for filepack
            filepack =  if File.file?( './filepack.txt')
                            read_filepack( './filepack.txt' )
                        else
                             nil
                        end

            build_pathspecs( args, filepack: filepack )
         end




specs.each_with_index do |rec,i|
    datafiles = rec['datafiles']

    errors = []

   datafiles.each_with_index do |path,j|
      puts "==> [#{i+1}/#{specs.size}, #{j+1}/#{datafiles.size}] reading >#{path}<..."

      txt = read_text( path )
      parser = RaccMatchParser.new( txt, debug: opts[:debug] )
      tree = parser.parse

      dump_tree_stats( tree )

      if parser.errors?
         ## note - auto-add filename to errors
         parser.errors.each do |msg|
          ###
          ###   errors << [ path, *msg ] # note: use splat (*) to add extra values (starting with msg)
              errors << [path, msg]
         end
      end
   end


   if errors.size > 0
      puts
      pp errors
      puts
      puts "!!   #{errors.size} parse error(s) in #{datafiles.size} datafiles(s)"
   else
      puts
      puts "OK   no parse errors found in #{datafiles.size} datafile(s)"
   end

   ## add errors to rec via rec['errors'] to allow
   ##   for further processing/reporting
   rec['errors'] = errors
end


###
## generate a report if --file option used
if opts[:file]

  buf = SportDb::PathspecReport.new(
            specs,
            title: 'fbtree summary report' ).build

  puts
  puts "SUMMARY:"
  puts buf

  #  maybe write out in the future?
  # basedir  = File.dirname( opts[:file] )
  # basename = File.basename( opts[:file], File.extname( opts[:file] ))
end

puts "bye"
end


def self.dump_tree_stats( tree )
  stats = Hash.new(0)  ## track counts only for now
  tree.each do |node|
     stats[ node.class ] += 1
  end

  match_count  = stats[ RaccMatchParser::MatchLine ]
  goal_count   = stats[ RaccMatchParser::GoalLine ]
  lineup_count = stats[ RaccMatchParser::LineupLine ]

  puts "   #{match_count} MatchLine(s)"     if match_count > 0
  puts "   #{goal_count} GoalLine(s)"       if goal_count > 0
  puts "   #{lineup_count} LineupLine(s)"   if lineup_count > 0
end


end # module Fbtree