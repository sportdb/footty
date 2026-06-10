####
#  to run use:
#    $  ruby sandbox/test_find_more.rb


$LOAD_PATH.unshift( './lib' )
require 'fbtok'

path = '/sports/openfootball/belgium'


datafiles = Dir.glob( "#{path}/**/*.txt" )
pp datafiles


datafiles = SportDb::Pathspec.find( path )
pp datafiles
puts "  #{datafiles.size} datafile(s)"
puts

datafiles = SportDb::Pathspec.find( path, seasons: ['2023/24','2024'] )
pp datafiles
puts "  #{datafiles.size} datafile(s)"
puts


puts "bye"