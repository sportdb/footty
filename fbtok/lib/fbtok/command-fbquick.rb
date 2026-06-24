
module Fbquick


def self.main( args=ARGV )

 opts = { debug: false,
          file:  nil,
        }

 parser = OptionParser.new do |parser|
  parser.banner = "Usage: #{$PROGRAM_NAME} [options] DATAFILE or DIR"

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

    parser.on( "-f FILE", "--file FILE",
                    "read datafiles (pathspecs) via .csv file") do |file|
      opts[:file] = file
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
  SportDb::MatchParser.debug = true
  SportDb::QuickMatchReader.debug = true
else
  SportDb::QuickMatchReader.debug = false
  SportDb::MatchParser.debug      = false
  LogUtils::Logger.root.level = :info
end


## todo/check - use packs or projects or such
##                instead of specs - why? why not?
specs =  if opts[:file]
            read_pathspecs( opts[:file] )
         else
            ## check for filepack
            ##
            ## fix-fix-fix
            ##  add tool specific filepack
            ##       e.g. filepack.quik|quick.txt or such
            ##   to match first??
            ##   check a list of names!!
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
      quick = SportDb::QuickMatchReader.new( txt )
      matches = quick.parse

      if quick.errors?
        puts "!! #{quick.errors.size} error(s):"
        pp quick.errors

        quick.errors.each do |err|
          errors << [ path, *err ]   # note: use splat (*) to add extra values (starting with msg)
        end
      end
      puts "  #{matches.size} match(es)"
    end

    if errors.size > 0
      puts
      puts "!! #{errors.size} PARSE ERRORS in #{datafiles.size} datafile(s)"
      pp errors
    else
      puts
      pp datafiles
      puts "  OK - no parse errors in #{datafiles.size} datafile(s)"
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
            title: 'fbquick summary report' ).build

  puts
  puts "SUMMARY:"
  puts buf

  #  maybe write out in the future?
  # basedir  = File.dirname( opts[:file] )
  # basename = File.basename( opts[:file], File.extname( opts[:file] ))
end

puts "bye"
end

end  # module Fbquick