####
#  to run use:
#    $  ruby sandbox/test_find.rb


$LOAD_PATH.unshift( './lib' )
require 'fbtok'


path = '/sports/openfootball/internationals'
datafiles = SportDb::Parser::Opts._expand( path )
    
puts "  #{datafiles.size} datafile"


MATCH_RE =  SportDb::Parser::Opts::MATCH_RE

pp MATCH_RE.match( "internationals/fifi_wild_cup/2006/fifi_wild_cup.txt" )
pp MATCH_RE.match( "internationals/fifi_wild_cup/2006_fifi_wild_cup.txt" )


puts "bye"