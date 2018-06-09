# encoding: utf-8


require 'helper'



class TestClient < MiniTest::Test

  def setup
    @client = Footty.client
  end

  def xxx_test_todays_games
     client = Footty::Client.new
     ary = client.get_todays_games()
     ## note: returns empty array if no games scheduled/playing today
     pp ary

     assert_equal Array, ary.class     ## for now just check return type (e.g. assume Array for parsed JSON data)
  end



  def test_world_2018_round_1
    h = @client.get_round( 1 )

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
    assert_nil          h['matches'][0]['score1']
    assert_nil          h['matches'][0]['score2']
  end


  def test_world_2018_round_2
    h = @client.get_round( 2 )

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
    assert_nil          h['matches'][0]['score1']
    assert_nil          h['matches'][0]['score2']
  end


end # class TestClient
