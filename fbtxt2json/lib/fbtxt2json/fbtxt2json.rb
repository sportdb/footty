#####
## todo
##   add option for [no]-halt-on-error (default: false)
##      or use a different (shorter) name e.g. --resume?


module Fbtxt2json


def self.main( args=ARGV )

opts = {  debug:   false,
          output:  nil,
          summary: false,
          seasons: [],
       }


parser = OptionParser.new do |parser|
parser.banner = "Usage: #{$PROGRAM_NAME} [options] DATAFILES or DIRS"

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
                  "output to file / dir" ) do |output|
     opts[:output] = output
   end

   parser.on( "--summary",
                  "(auto-)generate summary (index.html) page (default: #{opts[:summary]})" ) do |summary|
     opts[:summary] = summary
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


###
##  two modes -   process directories or  concat(enate)d files
##
##   check if args is a directory
##
dirs  = 0
files = 0
paths.each do |path|
     if Dir.exist?( path )
        dirs  += 1
     elsif File.file?( path )   ## note - strictly File.exist? also checks for dirs (use File.file?)!!
        files += 1
     else ## not a file or dir repprt errr
         raise ArgumentError, "file/dir does NOT exist - #{path}"
     end
end

if dirs > 0 && files > 0
     raise ArgumentError, "#{files} file(s), #{dirs} dir(s) - can only process dirs or files but NOT both; sorry"
end




if files > 0
    do_files( paths, outpath: opts[:output]  )
elsif dirs > 0
    do_dirs( paths, outdir:        opts[:output],
                    seasons:       opts[:seasons],
                    write_summary: opts[:summary] )
else
   ## do nothing; no args
end


puts "bye"
end # self.main



def self.do_files( paths, outpath: nil )
    data = nil
    paths.each_with_index do |path,i|
      puts "==> reading file [#{i+1}/#{paths.size}] >#{path}<..."
      txt = read_text( path )
      more_data = parse( txt )

      if data.nil?
         data = more_data
      else
          ## concat matches
          ##  check if name match up!!!
          if data['name'] != more_data['name']
             raise ArgumentError, "cannot merge matchfiles - league names do NOT match: #{data['name']} != #{more_data['name']}"
          else
              data['matches'] += more_data['matches']
          end
      end
    end

     pp data
     puts
     puts "  #{data['matches'].size} match(es)"

    if outpath
       puts "==> writing matches to #{outpath}"
       write_json( outpath, data )
    end
end



def self.do_dirs( paths, outdir: nil,
                         seasons: [],
                         write_summary: false )

   ## use a html pre(formatted) text
   summary = String.new
   summary << "<pre>\n"
   summary << "run on #{Time.now.to_s}\n\n"   ## add version and such - why? why not?


   paths.each_with_index do |path,i|
      puts "==> reading dir [#{i+1}/#{paths.size}] >#{path}<..."
      summary << "==> [#{i+1}/#{paths.size}] dir #{path}\n"

      datafiles = SportDb::Pathspec._find( path, seasons: seasons )
      pp datafiles
      puts "   #{datafiles.size} datafile(s)"
      summary << "    #{datafiles.size} datafile(s)\n\n"

      datafiles.each do |datafile|
         txt = read_text( datafile )
         data = parse( txt )

         ## add stats to summary page
         summary << "- #{data['name']} | #{data['matches'].size} match(es) - #{datafile}\n"


         if outdir
            ### norm - File.expand_path !!!
            ##   note - use '.' to use (relative to) local directory !!!
            reldir = File.expand_path(File.dirname( path ))   ## keep last dir (in relative name)
            relpath = datafile.sub( reldir+'/', '' )
            dir     = File.dirname( relpath )
            ## puts "  reldir = #{reldir}, datafile = #{datafile}"
            ## puts "  relpath = #{relpath}, dir = #{dir}"
            basename = File.basename( relpath, File.extname(relpath))
            outpath  = "#{outdir}/#{dir}/#{basename}.json"
         else
           dir = File.dirname( datafile )
           basename = File.basename( datafile, File.extname(datafile) )
           outpath = "#{dir}/#{basename}.json"
         end
         puts "  writing matches to #{outpath}"
         write_json( outpath, data )
      end
   end

   summary << "</pre>"
   puts summary

   ## note - do NOT write-out summary if seasons filter is used!!!
   if outdir && write_summary && seasons.empty?
     write_text( "#{outdir}/index.html", summary )
   end
end



def self.parse( txt )   ### check - name parse_txt or txt_to_json or such - why? why not?
   quick = SportDb::QuickMatchReader.new( txt )
   matches = quick.parse
   name    = quick.league_name   ## quick hack - get league+season via league_name

   data = { 'name'    => name,
            'matches' => matches.map {|match| match.as_json }}


   if quick.errors?
      puts "!! #{quick.errors.size} parse error(s):"
      pp quick.errors
      exit 1
   end

   data
end


end # module Fbtxt2json