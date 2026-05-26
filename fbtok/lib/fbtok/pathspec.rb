

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
    MATCH_RE = %r{
                    ## "classic" variant i)  with season folder
                    ##     e.g.  /1930/cup.txt
                    (?:
                      (?: ^|/ )    # beginning (^) or beginning of path (/)

                       #{SEASON_RE}
                          (?:  --[a-z0-9_-]+
                          )?
                         /
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
                }x

    ### add support for matchdatafile with season NOT in directory
    ##      but starting filename e.g. 2024_friendlies.txt or 2024-25_bundesliga.txt


def self._norm_seasons( seasons )
    seasons.map {|season| Season(season) }
end


## todo/check - rename to glob or expand or such - why? why not?
def self._find( path, seasons: nil )
    ## check - rename dir
    ##          use root_dir or work_dir or cd or such - why? why not?


    ## note: normalize path - use File.expand_path ??
    ##    change all backslash to slash for now
    ## path = path.gsub( "\\", '/' )
    path =  File.expand_path( path )

    ####
    ## note - make sure path exists; raise error if not
    raise Errno::ENOENT, "No such directory - #{path})"  unless Dir.exist?( path )


    if seasons && seasons.size > 0
       seasons = _norm_seasons( seasons )    ## norm seasons (string, integer => Season obj)
    end


    ## check all txt files
    ## note: incl. files starting with dot (.)) as candidates
    ##     (normally excluded with just *)
    ##  was:  Dir.glob( "#{path}/**/{*,.*}.txt" )

    candidates = Dir.glob( "#{path}/**/*.txt" )
    ## pp candidates


    datafiles = []
    candidates.each do |candidate|
       if m = MATCH_RE.match( candidate )

          ## check for seasons filter
          next   if seasons && seasons.size > 0 &&
                    !seasons.include?( Season.parse( m[:season] ))

          ### exclude squad
          ##   and .v2 or .v2603
          ##
          ##    - worldcup/more/1930_squads.txt   =>   squads
          ##    - 2014--brazil/cup.v2.txt",
          ##    - 2014--brazil/cup.v260318_164934.txt",

          basename = File.basename( candidate, File.extname( candidate ))

          next   if /squad/i.match( basename )
          next   if /\.v[0-9][0-9_]*/i.match( basename )


          datafiles << candidate
       end
    end

    ## pp datafiles
    datafiles
end





def self.read( src )
    recs = read_csv( src )
    pp recs     if debug?

    ##  note - make pathspecs relative to passed in file arg!!!
    basedir = File.dirname( src )

    recs.each do |rec|
        path = rec['path']
        fullpath = File.expand_path( path, basedir )
        datafiles =   _find( fullpath )

        ## add (new) datafiles column (from expanded pathspec)
        rec['datafiles'] = datafiles
    end

    recs
end




end  # class Pathspec



##
#  PathspecReport (aka/formerly BatchReport)

class PathspecReport
  def initialize( specs, title: )
     @specs = specs
     @title = title
  end

  def build
     buf = String.new
     buf << "# #{@title} - #{@specs.size} dataset(s)\n\n"

     @specs.each_with_index do |rec,i|
       datafiles  = rec['datafiles']
       errors     = rec['errors']

       if errors.size > 0
         buf << "!! #{errors.size} ERROR(S)  "
       else
         buf << "   OK          "
       end
       buf << "%-20s" % rec['path']
       buf << " - #{datafiles.size} datafile(s)"
       buf << "\n"

       if errors.size > 0
         buf << errors.pretty_inspect
         buf << "\n"
       end
     end

     buf
  end   # method build
end  # class BatchReport

BatchReport = PathspecReport

end  # module Sportdb



##
##  keep helpers as global functions - why? why not?



def build_pathspecs( args )    ### note:   was expand_args
   specs = []

   ## note - collect all "loose/standalone" files (NOT directories)
   ##             in single default pathspec node
   more = []

   args.each do |arg|
    ## check if directory
    if Dir.exist?( arg )
          datafiles = SportDb::Pathspec._find( arg )
          specs << { 'path'       => arg,
                     'datafiles'  => datafiles }
    elsif File.file?( arg )  ## assume it's a file
        ## make sure path exists; raise error if not
        ##   (auto-)expand path to normalize - why? why not?
          more << arg
    else
        raise Errno::ENOENT, "No such file or directory - #{arg}"
    end
  end

   if more.size > 0
      specs << { 'path'      => '<input>',
                 'datafiles' =>  more }
   end

  specs
end



def read_pathspecs( src )
    SportDb::Pathspec.read( src )
end
