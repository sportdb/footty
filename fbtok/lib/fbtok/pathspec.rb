

module SportDb
class Pathspec

  def self.debug=(value) @@debug = value; end
  def self.debug?()      @@debug ||= false; end  ## note: default is FALSE



    SEASON_RE = %r{ (?:
                          (?<season>\d{4}-\d{2})
                        | (?<season>\d{4})
                    )
                  }x

    ## note: if pattern includes directory add here
    ##     (otherwise move to more "generic" datafile) - why? why not?
    ##   update - note include/allow dot (.) too
    ##     BUT NOT as first character!!! (e.g. exclude .confg.txt !!!)
    ##               e.g. 2024-25/at.1.txt
    ##                        change to at_1 or uefa_cl or such - why? why not?
    ##
    ##   note - support case-insensitive flag  (e.g. 2025-26/namur/2_Prov_A.txt)

    MATCH_RE = %r{
                    ## "classic" variant i)  with season folder
                    ##     e.g.  /1930/cup.txt
                    (?:
                      (?: ^|/ )    # beginning (^) or beginning of path (/)

                       #{SEASON_RE}
                          (?:  --[a-z0-9_-]+
                          )?
                         /

                        ### note - allow optional directories
                        (?:
                            [a-z0-9][a-z0-9_-]*
                              /
                        )*

                       [a-z0-9][a-z0-9._-]* \.txt   ## e.g /1-premierleague.txt
                         $
                    )

                      |
                    ## "compact" variant ii) with season in filename
                    ##         e.g. 1930.txt or 2024_br.txt etc.
                    (?:
                       (?: ^|/ )      # beginning (^) or beginning of path (/)
                         #{SEASON_RE}
                         (?:   _   ## allow more than one underscore - why? why not?
                            [a-z0-9][a-z0-9._-]*
                          )?
                            \.txt
                            $
                    )
                }xi

    ### add support for matchdatafile with season NOT in directory
    ##      but starting filename e.g. 2024_friendlies.txt or 2024-25_bundesliga.txt




## todo/check - rename to glob or expand or such - why? why not?

##
##  todo - add a strict: true|false or   all: true|false or such option
##                    that will use generic **/*.txt and only use ignore filter!!!


def self._find( path, seasons: nil )
    ##
    ## note -  only if seasons filter is turn on
    ##                     MATCH_RE gets used!!!
    ##            otherwise generic **/*.txt
    ##
    ## note -   the ignore/exlude filter always gets used/applied for now


    ## check - rename dir
    ##          use root_dir or work_dir or cd or such - why? why not?

    ## note: normalize path - use File.expand_path ??
    ##    change all backslash to slash for now
    ## path = path.gsub( "\\", '/' )
    fullpath =  File.expand_path( path )

    ####
    ## note - make sure path exists; raise error if not
    raise Errno::ENOENT, "No such directory - #{path})"  unless Dir.exist?( fullpath )


    if seasons && seasons.size > 0
       ## norm seasons (string, integer => Season obj)
       seasons =  seasons.map {|season| Season(season) }
    end


    ## check all txt files
    ## note: incl. files starting with dot (.)) as candidates
    ##     (normally excluded with just *)
    ##  was:  Dir.glob( "#{path}/**/{*,.*}.txt" )

    candidates = Dir.glob( "#{fullpath}/**/*.txt" )
    ## pp candidates


    datafiles = []
    candidates.each do |candidate|

         ## (i) check for (optional) seasons filter
         if seasons && seasons.size > 0
            if m=MATCH_RE.match( candidate )
               next   unless seasons.include?( Season.parse( m[:season] ))
            else
              next    ## note - no season found in filename; skip too
            end
         end


         ## (ii) check for (default/built-in) ignore/excludes
          basename = File.basename( candidate, File.extname( candidate ))
          dirname  = File.dirname( candidate )

          ### exclude basenames with:
          ##   - squad
          ##   - .v2 or .v2603
          ##
          ##    - worldcup/more/1930_squads.txt   =>   squads
          ##    - 2014--brazil/cup.v2.txt
          ##    - 2014--brazil/cup.v260318_164934.txt

          next   if /squad/i.match?( basename )
          next   if /\.v[0-9][0-9_]*/i.match?( basename )

          #####
          ### exclude dirs  with:
          ##    - squad or wiki
          next   if /squad|wiki/i.match?( dirname )


          datafiles << candidate
    end

    ## pp datafiles
    datafiles
end




##
## rename/change to read_csv - why? why not?
def self.read( src )
    ## note: normalize scr - use File.expand_path ??
    ##    change all backslash to slash for now
    ## scr = scr.gsub( "\\", '/' )
    fullsrc =  File.expand_path( scr )

    recs = read_csv( fullsrc )
    pp recs     if debug?

    ##  note - make pathspecs relative to passed in file arg!!!
    basedir = File.dirname( fullsrc )

    recs.each do |rec|
        path = rec['path']
        fullpath = File.expand_path( path, basedir )
        datafiles =   _find( fullpath )

        ## add (new) datafiles column (from expanded pathspec)
        rec['datafiles'] = datafiles
    end

    recs
end



def self.build( args, filepack: nil )
  recs = []

  ## check fo no args case  (and filepack present with default)
  if args.empty?
    if filepack && filepack.has_key?('default')
               recs << { 'path'      => '<default>',
                         'datafiles' => filepack['default'] }
    end
  else

    ## note - collect all "loose/standalone" files (NOT directories)
    ##             in single default pathspec node
    more = []


    args.each do |arg|
      if filepack && filepack.has_key?( arg.downcase )
           recs << { 'path'      => "<#{arg.downcase}>",
                     'datafiles' => filepack[arg.downcase] }
      ## check if directory
      elsif Dir.exist?( arg )
          recs << { 'path'       => arg,
                    'datafiles'  => _find( arg ) }
      elsif File.file?( arg )  ## assume it's a file
        ## make sure path exists; raise error if not
        ##   (auto-)expand path to normalize - yes why? why not?
          more << File.expand_path( arg )
      else
        raise Errno::ENOENT, "No such file or directory - #{arg}"
      end
    end

    if more.size > 0
      recs << { 'path'      => '<input>',
                'datafiles' =>  more }
    end
  end

  recs
end

end  # class Pathspec
end  # module Sportdb




##
##  keep helpers as global functions - why? why not?


##  build pathspecs via arguments
##   - (i) every dir is a pathspec entry/record
##   - (ii) all files get bundled together into <input> pathspec entry/record
##
##   note: was formerly known as expand_args
def build_pathspecs( args, filepack: nil )
   SportDb::Pathspec.build( args, filepack: filepack )
end

####
## read pathspecs via csv file (using path column)
def read_pathspecs( src )
    SportDb::Pathspec.read( src )
end
