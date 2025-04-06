####
#  to run use:
#    $  ruby sandbox/test_seasons.rb


$LOAD_PATH.unshift( './lib' )
require 'fbtok'

path = '/sports/openfootball/england'
## path = '/sports/openfootball/austria'
## path = '/sports/openfootball/italy'
## path = '/sports/openfootball/europe'


datafiles = SportDb::Parser::Opts._find( path )
pp datafiles
puts "  #{datafiles.size} datafile"
puts

datafiles = SportDb::Parser::Opts._find( path, seasons: ['2023/24','2024'] )
pp datafiles
puts "  #{datafiles.size} datafile"
puts

datafiles = SportDb::Parser::Opts._find( path, seasons: ['2024/25','2025'] )
pp datafiles
puts "  #{datafiles.size} datafile"


puts "bye"