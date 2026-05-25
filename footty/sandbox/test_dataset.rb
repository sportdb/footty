####
#  to run use:
#    $  ruby sandbox/test_dataset.rb


$LOAD_PATH.unshift( './lib' )
require 'footty'


#  league: 'euro', season: '2020'
#  league: 'euro', season: '2024'
#  league: 'world', season: '2018'


dataset = Footty::OpenfootballDataset.new( league: 'de', season: '2025/26' )

matches = dataset.matches
pp matches


puts "bye"