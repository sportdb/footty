####
#  to run use:
#    $  ruby sandbox/test_expand.rb


basedir = "/sports/openfootball"
name = "./austria"
puts File.expand_path( name, basedir )


puts File.expand_path( "./austria" )
puts File.expand_path( "austria" )

puts "bye"