###
#  to run use
#     ruby -I ./lib -I ./test test/test_client_worldcup.rb

require 'helper'



class TestClientWorldCup < MiniTest::Test

  def setup
    @client = Footty::Client.new( league: 'worldcup', year: 2018 )
  end


  def test_getters
    today = Date.new( 2018, 6, 16 )

    todays     = @client.todays_matches( date: today )
    pp todays
    assert_equal 4,     todays.size

    yesterdays = @client.yesterdays_matches( date: today )
    pp yesterdays
    assert_equal 3,     yesterdays.size

    tomorrows  = @client.tomorrows_matches( date: today )
    pp tomorrows
    assert_equal 3,     tomorrows.size

    past     = @client.past_matches( date: today )
    pp past

    upcoming = @client.upcoming_matches( date: today )
    pp upcoming
  end



  def test_todays_matches_2018_6_14
     today = Date.new( 2018, 6, 14 )
     ary = @client.todays_matches( date: today )
     ## pp ary
=begin
[{"num"=>1,
  "date"=>"2018-06-14",
  "time"=>"18:00",
  "team1"=>{"name"=>"Russia", "code"=>"RUS"},
  "team2"=>{"name"=>"Saudi Arabia", "code"=>"KSA"},
  "score1"=>nil,
  "score2"=>nil,
  "score1i"=>nil,
  "score2i"=>nil,
  "group"=>"Group A",
  "stadium"=>{"key"=>"luzhniki", "name"=>"Luzhniki Stadium"},
  "city"=>"Moscow",
  "timezone"=>"UTC+3",
  "round"=>"Matchday 1"}]
=end

     assert_equal Array, ary.class     ## for now just check return type (e.g. assume Array for parsed JSON data)
     assert_equal 1,     ary.size
     assert_equal 'RUS',        ary[0]['team1']['code']
     assert_equal 'KSA',        ary[0]['team2']['code']
     assert_equal 'Matchday 1', ary[0]['round']
     assert_equal 5,            ary[0]['score1']
     assert_equal 0,            ary[0]['score2']
  end

  def test_todays_matches_2018_6_10
     today = Date.new( 2018, 6, 10 )
     ary = @client.todays_matches( date: today )
     ## note: returns empty array if no matches scheduled/playing today
     pp ary

     assert_equal Array, ary.class     ## for now just check return type (e.g. assume Array for parsed JSON data)
     assert              ary.empty?
  end

  def test_world_2018_round_1
    h = @client.round( 1 )

    ## pp h
=begin
{"name"=>"Matchday 1",
 "matches"=>
  [{"num"=>1,
    "date"=>"2018-06-14",
    "time"=>"18:00",
    "team1"=>{"name"=>"Russia", "code"=>"RUS"},
    "team2"=>{"name"=>"Saudi Arabia", "code"=>"KSA"},
    "score1"=>nil,
    "score2"=>nil,
    "score1i"=>nil,
    "score2i"=>nil,
    "group"=>"Group A",
    "stadium"=>{"key"=>"luzhniki", "name"=>"Luzhniki Stadium"},
    "city"=>"Moscow",
    "timezone"=>"UTC+3"}]}
=end

    assert_equal 'RUS', h['matches'][0]['team1']['code']
    assert_equal 'KSA', h['matches'][0]['team2']['code']
    assert_equal 5,     h['matches'][0]['score1']
    assert_equal 0,     h['matches'][0]['score2']
  end


  def test_world_2018_round_2
    h = @client.round( 2 )

    ## pp h
=begin
{"name"=>"Matchday 2",
 "matches"=>
  [{"num"=>2,
    "date"=>"2018-06-15",
    "time"=>"17:00",
    "team1"=>{"name"=>"Egypt", "code"=>"EGY"},
    "team2"=>{"name"=>"Uruguay", "code"=>"URU"},
    "score1"=>nil,
    "score2"=>nil,
    "score1i"=>nil,
    "score2i"=>nil,
    "group"=>"Group A",
    "stadium"=>{"key"=>"ekaterinburg", "name"=>"Ekaterinburg Arena"},
    "city"=>"Ekaterinburg",
    "timezone"=>"UTC+5"},
   {"num"=>3,
    "date"=>"2018-06-15",
    "time"=>"21:00",
    "team1"=>{"name"=>"Portugal", "code"=>"POR"},
    "team2"=>{"name"=>"Spain", "code"=>"ESP"},
    "score1"=>nil,
    "score2"=>nil,
    "score1i"=>nil,
    "score2i"=>nil,
    "group"=>"Group B",
    "stadium"=>{"key"=>"fisht", "name"=>"Fisht Stadium"},
    "city"=>"Sochi",
    "timezone"=>"UTC+3"},
   {"num"=>4,
    "date"=>"2018-06-15",
    "time"=>"18:00",
    "team1"=>{"name"=>"Morocco", "code"=>"MAR"},
    "team2"=>{"name"=>"Iran", "code"=>"IRN"},
    "score1"=>nil,
    "score2"=>nil,
    "score1i"=>nil,
    "score2i"=>nil,
    "group"=>"Group B",
    "stadium"=>{"key"=>"saintpetersburg", "name"=>"Saint Petersburg Stadium"},
    "city"=>"Saint Petersburg",
    "timezone"=>"UTC+3"}]}
=end

    assert_equal 'EGY', h['matches'][0]['team1']['code']
    assert_equal 'URU', h['matches'][0]['team2']['code']
    assert_equal  0,    h['matches'][0]['score1']
    assert_equal  1,    h['matches'][0]['score2']
  end


end # class TestClientWorldCup
