####
#  to run use:
#    $  ruby sandbox/test_client.rb


$LOAD_PATH.unshift( './lib' )
require 'footty'


# client = Footty::Client.new( league: 'euro', year: 2020 )
# client = Footty::Client.new( league: 'euro', year: 2024 )
# client = Footty::Client.new( league: 'worldcup', year: 2018 )


client = Footty::Client.new( league: 'de', year: 2024 ) ## season 2024/25

data = client.get_matches
pp data


puts "bye"