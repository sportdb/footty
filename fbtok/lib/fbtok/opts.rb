
module SportDb
class Parser


###
## note - Opts Helpers for now nested inside Parser - keep here? why? why not?
class Opts

  def self.debug=(value) @@debug = value; end
  def self.debug?()      @@debug ||= false; end  ## note: default is FALSE
  

    SEASON_RE = %r{ (?:
                       (?<season>\d{4}-\d{2})
                        | 
                       (?<season>\d{4}) 
                         (?: --[a-z0-9_-]+ )?   ## todo/fix - allow "extension" to 2024-25 too - why?
                    )
                  }x
    SEASON = SEASON_RE.source    ## "inline" helper for embedding in other regexes - keep? why? why not?


    ## note: if pattern includes directory add here
    ##     (otherwise move to more "generic" datafile) - why? why not?
    ##   update - note include/allow dot (.) too
    ##     BUT NOT as first character!!! (e.g. exclude .confg.txt !!!)
    ##               e.g. 2024-25/at.1.txt
    ##                        change to at_1 or uefa_cl or such - why? why not?
    MATCH_RE = %r{ (?:   ## "classic"  variant i)  with season folder
                      (?: ^|/ )      # beginning (^) or beginning of path (/)
                       #{SEASON}
                         /
                       [a-z0-9][a-z0-9_.-]*\.txt$  ## txt e.g /1-premierleague.txt
                    )
                     |
                    (?:  ## "compact" variant ii) with season in filename
                       (?: ^|/ )      # beginning (^) or beginning of path (/)
                        (?:  (?<season>\d{4}-\d{2}) 
                                | 
                             (?<season>\d{4})
                         )
                         _  ## allow more than one underscore - why? why not?
                        [a-z0-9][a-z0-9_.-]*\.txt$           
                    )
                }x

    ### add support for matchdatafile with season NOT in directory
    ##      but starting filename e.g. 2024_friendlies.txt or 2024-25_bundesliga.txt


def self._find( path, seasons: nil )
    ## check - rename dir
    ##          use root_dir or work_dir or cd or such - why? why not?

    datafiles = []

    ## note: normalize path - use File.expand_path ??
    ##    change all backslash to slash for now
    ## path = path.gsub( "\\", '/' )
    path =  File.expand_path( path )
          
    if seasons && seasons.size > 0
       ## norm seasons
       seasons = seasons.map {|season| Season(season) }
    end


    ## check all txt files
    ## note: incl. files starting with dot (.)) as candidates
    ##     (normally excluded with just *)
    candidates = Dir.glob( "#{path}/**/{*,.*}.txt" )
    ## pp candidates
    candidates.each do |candidate|
       if m=MATCH_RE.match( candidate )
          if seasons && seasons.size > 0   ## check for seasons filter 
            season = Season.parse(m[:season])
            datafiles << candidate   if seasons.include?( season )   
          else
            datafiles << candidate 
          end  
       end
    end

    ## pp datafiles
    datafiles
end


def self._expand( arg )
    ## check if directory
    if Dir.exist?( arg )
          datafiles = _find( arg )
          if debug?
            puts
            puts "  found #{datafiles.size} match txt datafiles in #{arg}"
            pp datafiles
          end
          datafiles
    else ## assume it's a file
        ## make sure path exists; raise error if not 
        if File.exist?( arg )
          [arg]   ## note - always return an array - why? why not?
        else    
          raise Errno::ENOENT, "No such file or directory - #{arg}" 
        end
    end
end


def self.expand_args( args )
  paths = []
  args.each do |arg|
    paths += _expand( arg )
  end
  paths 
end



## todo/check - find a better name 
##   e.g.  BatchItem or PackageDef or ???
##
##   find a different name for rec for named value props?
##      why? why not?
PathspecNode = Struct.new( :paths, :rec )

def self.build_pathspec( paths: )
    PathspecNode.new( paths: paths, rec: {} )
end

def self.read_pathspecs( src )
    specs = []

    recs = read_csv( src )
    pp recs     if debug?
  
    ##  note - make pathspecs relative to passed in file arg!!!
    basedir = File.dirname( src )
    recs.each do |rec|
        path = rec['path']
        fullpath = File.expand_path( path, basedir ) 
        ## make sure path exists; raise error if not
        paths =  if Dir.exist?( fullpath )
                    _find( fullpath )
                 else
                    raise Errno::ENOENT, "No such directory - #{fullpath})" 
                 end
        
        specs << PathspecNode.new( paths: paths, rec: rec )
    end
    specs
end
end  # class Opts


##
#  BatchReport (a.k.a. PathspecsReport)

class BatchReport

  def initialize( specs, title: )
     @specs = specs
     @title = title
  end

  def build
     buf = String.new
     buf << "# #{@title} - #{@specs.size} dataset(s)\n\n"
  
     @specs.each_with_index do |spec,i|
       paths  = spec.paths
       rec    = spec.rec
       errors = rec['errors']
  
       if errors.size > 0
         buf << "!! #{errors.size} ERROR(S)  "
       else
         buf << "   OK          "
       end
       buf << "%-20s" % rec['path']
       buf << " - #{paths.size} datafile(s)"
       buf << "\n"
  
       if errors.size > 0
         buf << errors.pretty_inspect
         buf << "\n"
       end
     end
  
     buf
  end   # method build
end  # class BatchReport
end   # class Parser
end   # module SportDb