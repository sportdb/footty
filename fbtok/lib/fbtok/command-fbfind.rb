

module Fbfind

def self.main( args=ARGV )

opts = {
    debug: false,
    file:  nil,
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

  parser.on( "--seasons SEASONS",
               "filter by seasons (default: #{opts[:seasons]})") do |seasons|
    opts[:seasons] = seasons
                        .split( /[,:]/ )
                        .map { |season| Season.parse(season.strip) }
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


if opts[:debug]
  puts
  puts "pathspecs:"
  pp specs
end


if opts[:seasons].size > 0
   specs = filter_pathspecs( specs, seasons: opts[:seasons] )
end

puts
specs.each_with_index do |rec,i|
    path = rec['path']
    datafiles = rec['datafiles']

    print "==> [#{i+1}/#{specs.size}] #{path}"
    print "  (incl. seasons #{opts[:seasons]})"     if opts[:seasons].size > 0
    print "...\n"
    pp datafiles
    puts "   #{datafiles.size} datafile(s)"
end

puts "bye"
end

end  ## module Fbfind
