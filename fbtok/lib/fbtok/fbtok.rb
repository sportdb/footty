
module Fbtok


def self.main( args=ARGV )

opts = {
    debug: true,
    file:  nil,
#    warn:  false,
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

            path = SportDb::Pathspec.path(
                          ['/sports/sportdb/sport.db.v2/parser/fbtxt-specs',
                           '/sports/sportdb/sport.db.v2/parser/fbtxt-samples',
                           '/sports/openfootball'])

            build_pathspecs( args, path: path,
                                   filepack: filepack )
         end


pp specs



specs.each_with_index do |rec,i|
    datafiles = rec['datafiles']

    errors = []

    datafiles.each_with_index do |path,j|
      puts "==> [#{i+1}/#{specs.size}, #{j+1}/#{datafiles.size}] reading >#{path}<..."

      txt = read_text( path )
      lexer = SportDb::Lexer.new( txt, debug: opts[:debug] )
      tokens, more_errors = lexer.tokenize_with_errors

      ####
      ## todo - report error on empty file (no tokens!!!) - why? why not?

      puts "   #{tokens.size} token(s)"

      if more_errors.size > 0
         ## note - auto-add filename to errors
         more_errors.each do |msg|
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
      puts "!!   #{errors.size} tokenize error(s) in #{datafiles.size} datafiles(s)"
   else
      puts
      pp datafiles
      puts "OK   no tokenize errors found in #{datafiles.size} datafile(s)"
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
            title: 'fbtok summary report' ).build

  puts
  puts "SUMMARY:"
  puts buf

  #  maybe write out in the future?
  # basedir  = File.dirname( opts[:file] )
  # basename = File.basename( opts[:file], File.extname( opts[:file] ))
end

puts "bye"

end  # self.main
end  # module Fbtok