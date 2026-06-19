



module SportDb
class Pathspec

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


def self.find( path, seasons: nil )
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
    fullpath =  File.expand_path( path )

    ####
    ## note - make sure path exists; raise error if not
    ##   ENOENT => Error No Entity
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


def self.path( default=[])
 ## check for  FBPATH
 ##         or FBTXT_PATH
      path = ENV['FBPATH'] || ENV['FBTXT_PATH']
      if path
          path.split( /[:;]/)
      else
         default
      end
end
end # class Pathspec





class Pathspecs    ## change to a module - why? why not?


def self.debug=(value) @@debug = value; end
def self.debug?()      @@debug ||= false; end     ## note: default is FALSE


def self.read( src )
    ## note: normalize src - use File.expand_path ??
    ##    change all backslash to slash for now (\ to /)
    fullsrc =  File.expand_path( src )

    recs = read_csv( fullsrc )
    pp recs     if debug?

    ##  note - make pathspecs relative to passed in file arg!!!
    basedir = File.dirname( fullsrc )

    recs.each do |rec|
        ##
        ## todo/check - check for season/seasons column - why? why not?
        path = rec['path']
        fullpath = File.expand_path( path, basedir )
        datafiles =   Pathspec.find( fullpath )

        ## auto-add (new) datafiles column (from expanded pathspec)
        rec['datafiles'] = datafiles
    end

    recs
end


## quick (internal) helper to
##    expand names (directories)  ending with /*
##                 with Pathspec.find
def self._expand_pathspecs( names )
   datafiles = []
   names.each do |name|
      if name.end_with?('/*')
         datafiles += Pathspec.find( name[0..-3] )
      else
         datafiles << name
      end
   end
   datafiles
end

def self.build( args, path: [],
                      filepack: nil )
  recs = []

  ## check fo no args case  (and filepack present with default)
  if args.empty?
    if filepack && filepack.has_key?('default')
               recs << { 'path'      => '<default>',
                         'datafiles' => _expand_pathspecs(filepack['default']) }
    end
  else

    ## note - collect all "loose/standalone" files (NOT directories)
    ##             in single default pathspec node
    more = []

    args.each do |arg|
       ## note - ALWAYS give priority to existing directory matches (over filepack)
       ##             e.g. euro or such -  why? why not?
       ##
       ##  todo/check  if euro/ works too?
       ## check if directory
       ##     note - make find_dir/path lookup an env variable
       ##               e.g. FBTXT_ROOTDIR, FBTXT_SOURCE, FBSOURCE,
       ##                    FBTXT_REPOS/PACKS/etc. or such!!!
       ##     add dir_path/dirs or such to build - why? why not?
       if dir=find_dir( arg, path: ['/sports/openfootball']  )
          recs << { 'path'       => arg,
                    'datafiles'  => Pathspec.find( dir ) }
       elsif filepack && filepack.has_key?( arg.downcase )
           recs << { 'path'      => "<#{arg.downcase}>",
                     'datafiles' => _expand_pathspecs(filepack[arg.downcase]) }
       else   ## assume it's a file
           file = find_file( arg, path: path )
            ## check if file (exists) in any path lookup
            if file
              ## todo/fix:
              ##   add File.expand_path upstream in find_file !!!
              ##           and remove later here
              ##       also fix upstream Errorno::ENOENT to Errno::ENOENT !!!
              ##
              ## make sure path exists; raise error if not
               ## (auto-)expand path to normalize - yes why? why not?
              more << File.expand_path(file)
            else
              raise Errno::ENOENT, "No such file or directory - #{arg}"
            end
       end
    end

    if more.size > 0
      recs << { 'path'      => '<input>',
                'datafiles' =>  more }
    end
  end

  recs
end

end  # class Pathspecs
end  # module Sportdb




##
##  keep helpers as global functions - why? why not?


##  build pathspecs via arguments
##   - (i) every dir is a pathspec entry/record
##   - (ii) all files get bundled together into <input> pathspec entry/record
##
##   note: was formerly known as expand_args
def build_pathspecs( args, path: [], filepack: nil )
   SportDb::Pathspecs.build( args, path: path, filepack: filepack )
end

####
## read pathspecs via csv file (using path column)
def read_pathspecs( src )
    SportDb::Pathspecs.read( src )
end



def filter_pathspecs( specs, seasons: )
    ## norm seasons
    seasons =  seasons.map {|season| Season(season) }

    ##  todo/fix: auto-add/update  rec['seasons'] column - why? why not?

    ## note - filter datafiles inplace!!!
    specs.each do |rec|
       rec['datafiles'] =
       rec['datafiles'].select do |candidate|
             m=SportDb::Pathspec::MATCH_RE.match( candidate )
             if m && seasons.include?( Season.parse( m[:season] ))
                true
             else
                false
             end
        end
    end

    specs
end
