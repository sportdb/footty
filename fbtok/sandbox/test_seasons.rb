####
#  to run use:
#    $  ruby sandbox/test_seasons.rb


$LOAD_PATH.unshift( './lib' )
require 'fbtok'

path = '/sports/openfootball/england'
## path = '/sports/openfootball/austria'
## path = '/sports/openfootball/italy'
## path = '/sports/openfootball/europe'


datafiles = SportDb::Pathspec.find( path )
pp datafiles
puts "  #{datafiles.size} datafile(s)"
puts

seasons = ['2023/24','2024']
pp seasons
datafiles = SportDb::Pathspec.find( path, seasons: seasons )
pp datafiles
puts "  #{datafiles.size} datafile(s)"
puts

seasons = ['2024/25','2025']
pp seasons
datafiles = SportDb::Pathspec.find( path, seasons: seasons )
pp datafiles
puts "  #{datafiles.size} datafile(s)"


puts "bye"