# encoding: utf-8


require 'helper'

class TestClient < MiniTest::Unit::TestCase

  def test_todays_games
     client = Footty::Client.new
     ary = client.get_todays_games()
     ## note: returns empty array if no games scheduled/playing today
     pp ary

     assert_equal Array, ary.class     ## for now just check return type (e.g. assume Array for parsed JSON data)
  end

  def test_world_2014_round_1
    client = Footty::Client.new
    h = client.get_round( 1 )

    ## pp h
=begin
{"event"=>{"key"=>"world.2014", "title"=>"World Cup 2014"},
 "round"=>
  {"pos"=>1,
   "title"=>"Matchday 1",
   "start_at"=>"2014/06/12",
   "end_at"=>"2014/06/12"},
 "games"=>
  [{"team1_key"=>"bra",
    "team1_title"=>"Brazil",
    "team1_code"=>"BRA",
    "team2_key"=>"cro",
    "team2_title"=>"Croatia",
    "team2_code"=>"CRO",
    "play_at"=>"2014/06/12",
    "score1"=>3,
    "score2"=>1,
    "score1ot"=>nil,
    "score2ot"=>nil,
    "score1p"=>nil,
    "score2p"=>nil}]}
=end

    assert_equal 'bra', h['games'][0]['team1_key']
    assert_equal 'cro', h['games'][0]['team2_key']
    assert_equal 3,     h['games'][0]['score1']
    assert_equal 1,     h['games'][0]['score2']
  end

end # class TestClient
