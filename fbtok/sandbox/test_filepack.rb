####
#  to run use:
#    $  ruby sandbox/test_filepack.rb


$LOAD_PATH.unshift( './lib' )
require 'fbtok'


h = read_filepack( './sandbox/filepack.txt' )

pp h

puts "bye"