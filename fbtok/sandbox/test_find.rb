####
#  to run use:
#    $  ruby sandbox/test_find.rb


$LOAD_PATH.unshift( './lib' )
require 'fbtok'


path = '/sports/openfootball/internationals'
datafiles = Fbtxt::Pathspec.find( path )

## pp datafiles
puts "  #{datafiles.size} datafile(s)"


MATCH_RE =  Fbtxt::Pathspec::MATCH_RE

pp MATCH_RE.match( "internationals/fifi_wild_cup/2006/fifi_wild_cup.txt" )
pp MATCH_RE.match( "internationals/fifi_wild_cup/2006_fifi_wild_cup.txt" )
pp MATCH_RE.match( "internationals/fifi_wild_cup/2006.txt" )


##
## check for new FBPATH|FBTXT_PATH env
##
## todo/check - change to Fbtxt.path  - why? why not?
##                or Fbtxt::Env.path  or ???


pp Fbtxt::Pathspec.path
pp Fbtxt::Pathspec.path( ['/sports/openfootball', '.'] )

puts "bye"