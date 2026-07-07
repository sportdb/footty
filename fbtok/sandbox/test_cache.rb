####
#  to run use:
#    $  ruby sandbox/test_cache.rb


$LOAD_PATH.unshift( './lib' )
require 'fbtok'

path = '/sports/tmp/cache'

datafiles = Fbtxt::Pathspec.find( path )
pp datafiles
puts "  #{datafiles.size} datafile(s)"
puts

seasons = ['2025/26','2026']
pp seasons
datafiles = Fbtxt::Pathspec.find( path, seasons: seasons )
pp datafiles
puts "  #{datafiles.size} datafile(s)"
puts


seasons = ['2026/27']
pp seasons
datafiles = Fbtxt::Pathspec.find( path, seasons: seasons )
pp datafiles
puts "  #{datafiles.size} datafile(s)"
puts


puts "bye"