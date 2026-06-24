
module Fbtree

def self.main( args=ARGV )



opts = {
    debug: true,
##    warn:  false,

    json:  false,
    yaml:  false,

    file:  nil,
    tty:   false,

    seasons: [],
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
#  parser.on( "-w", "--warn",
#              "turn warnings into errors (default: #{opts[:warn]})" ) do |warn|
#    opts[:warn] = true
#  end


  parser.on( "-f FILE", "--file FILE",
                "read datafiles (pathspecs) via .csv file") do |file|
    opts[:file] = file
    ## note: for batch (massive) processing auto-set debug (verbose output) to false (as default)
    opts[:debug] = false
  end

  parser.on( "--seasons SEASONS",
               "filter by seasons (default: #{opts[:seasons]})") do |seasons|
    opts[:seasons] = seasons
                        .split( /[,:]/ )
                        .map { |season| Season.parse(season.strip) }
  end


  parser.on( "-j", "--json",
                "turn on output in json (default: #{opts[:json]})" ) do |json|
    opts[:json] = true
  end
  parser.on( "-y", "--yaml",
                "turn on output in yaml (default: #{opts[:yaml]})" ) do |yaml|
    opts[:yaml] = true
  end

  parser.on( "-t", "--terminal", "--tty",
             "force terminal/tty input (default: #{opts[:tty]})" ) do |tty|
    opts[:tty] = tty
  end
end
parser.parse!( args )

if opts[:debug]
  puts "OPTS:"
  p opts
  puts "ARGV:"
  p args

  SportDb::Lexer.debug = true
  RaccMatchParser.debug = true
end



## special case for typed input via terminal/tty
if opts[:tty]

   puts "type your football.TXT lines here (exit with ctrl-z and return):"
   lines = STDIN.readlines   ## note - readlines incl. trailing newline!

   txt = lines.join  ## note - join with no space (already incl. trailing newline!)

   puts "--- parsing #{lines.size} line(s) ---"
   puts txt
   puts "--- results ---"

   tree, errors = parse_with_errors( txt, opts )

   if errors.size > 0
      puts
      pp errors
      puts
      puts "!!   #{errors.size} parse error(s)"
      exit 1
   else
      puts
      puts "OK   no parse errors found"
      exit 0
   end
end



## check for piped input  e.g.  $ curl | fbtree
if !STDIN.tty?   ## input NOT via tty (teletype terminal)

   txt = STDIN.read

   puts "--- parsing ---"
   puts txt
   puts "--- results ---"

   tree, errors = parse_with_errors( txt, opts )

   if errors.size > 0
      puts
      pp errors
      puts
      puts "!!   #{errors.size} parse error(s)"
      exit 1
   else
      puts
      puts "OK   no parse errors found"
      exit 0
   end
end




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

            ##
            ## maybe change to:
            ##   Env.fbpath( default)
            ##   or  fb_path          or such - why? why not?

            path = SportDb::Pathspec.path(
                          ['/sports/sportdb/sport.db.v2/parser/fbtxt-specs',
                           '/sports/sportdb/sport.db.v2/parser/fbtxt-samples',
                           '/sports/openfootball'])

            build_pathspecs( args, path: path,
                                   filepack: filepack )
         end



## if more than single datafile
##     auto-switch into quite mode for now
## if specs.size > 0  && specs[0]['datafiles'].size > 1
##   opts[:debug] = false
## end



if opts[:seasons].size > 0
   specs = filter_pathspecs( specs, seasons: opts[:seasons] )
end



specs.each_with_index do |rec,i|
    datafiles = rec['datafiles']

    errors = []
    log    = []   ## quick one-line summary per datafile

   datafiles.each_with_index do |path,j|
      puts "==> [#{i+1}/#{specs.size}, #{j+1}/#{datafiles.size}] reading >#{path}<..."

      txt = read_text( path )
      tree, more_errors = parse_with_errors( txt, opts )

      if more_errors.size > 0
         ## note - auto-add filename to errors
         more_errors.each do |msg|
          ###
          ###   errors << [ path, *msg ] # note: use splat (*) to add extra values (starting with msg)
              errors << [path, msg]
         end

         log << [:ERROR, path, "#{more_errors.size} parse error(s), #{tree.size} tree node(s)"]
      else
         log << [:OK, path, "#{tree.size} tree node(s)"]
      end
   end


   if errors.size > 0
      puts
      pp errors
      puts
      puts
      pp log
      puts "!!   #{errors.size} parse error(s) in #{datafiles.size} datafiles(s)"
   else
      puts
      pp log
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



def self.parse_with_errors( txt, opts={} )
   parser = RaccMatchParser.new( txt )
   tree = parser.parse

   dump_tree_stats( tree )

   if opts[:yaml]
         puts "--- yaml ---"
         puts  YAML.dump( tree )
   end

   if opts[:json]
         puts "--- json ---"
         ## puts  JSON.pretty_generate( tree )
         ##
         ##   note - use hacky but more beautiful pretty_print
         txtjson =  tree.as_json.pretty_inspect
         txtjson =  txtjson.gsub( '=>', ': ' )
         puts txtjson
   end


   [tree, parser.errors]
end


end # module Fbtree