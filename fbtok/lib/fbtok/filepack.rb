###################
##
##  quick and dirty format for filepacks
##      that is, named list of files
##
##   note -  space indent(ation) does NOT matter
##



##  PACK eng|en
##  add NAME eng|en   - why? why not?
##
## change to FILEPACK_NAME - why? why not?
FILEPACK_HEADER_RE = %r{\A
                              (?: PACK ) [ ]+
                              (?<header> .+?)   ## note - use non-greedy
                          \z}x

##   DIR  /sports/openfootball
##   CD  /sports/openfootball     -- keep - why? why not?
FILEPACK_DIR_RE = %r{\A
                              (?: DIR|CD ) [ ]+
                              (?<dir> .+? )      ## note - use non-greedy

                      \z}x



def parse_filepack( txt )
    h={}
    recs    = nil
    basedir = nil

    txt.each_line do |line|
      line = line.strip

      next  if line.start_with?('#') || line.empty?

      break if line == '__END__'


      if m=FILEPACK_HEADER_RE.match(line)
        keys    = m[:header].strip.split(  /[ ]*\|[ ]*/ )
        basedir = nil
        recs = []
        ## note - normalize keys for now (always downcase)
        keys.each {|key| h[key.downcase] = recs }
      elsif m=FILEPACK_DIR_RE.match(line)
        basedir = m[:dir].strip
      else
        file =  basedir ? File.join( basedir, line ) : line
        recs << file
      end
    end

    h
end


def read_filepack( path )
  parse_filepack( read_text( path ))
end
