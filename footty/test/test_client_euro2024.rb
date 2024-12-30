###
#  to run use
#     ruby -I ./lib -I ./test test/test_client_euro2024.rb

require 'helper'



class TestClientEuro2024 < Minitest::Test

  def setup
    @client = Footty::Client.new( league: 'euro', year: 2024 )
  end


  def test_getters
    today = Date.new( 2024, 6, 15 )

    todays     = @client.todays_matches( date: today )
    pp todays
    assert_equal 3,     todays.size

    yesterdays = @client.yesterdays_matches( date: today )
    pp yesterdays
    assert_equal 1,     yesterdays.size

    tomorrows  = @client.tomorrows_matches( date: today )
    pp tomorrows
    assert_equal 3,     tomorrows.size

    past     = @client.past_matches( date: today )
    pp past

    upcoming = @client.upcoming_matches( date: today )
    pp upcoming
  end


  def test_todays_matches_2024_6_15
     today = Date.new( 2024, 6, 15 )
     ary = @client.todays_matches( date: today )
     pp ary
=begin
[{"num"=>31,
  "date"=>"2021-06-15",
  "team1"=>{"name"=>"Hungary", "code"=>"HUN"},
  "team2"=>{"name"=>"Portugal", "code"=>"POR"},
  "score1"=>nil,
  "score2"=>nil,
  "score1i"=>nil,
  "score2i"=>nil,
  "group"=>"Group F",
  "round"=>"Matchday 1"},
  ...
=end

     assert_equal Array, ary.class     ## for now just check return type (e.g. assume Array for parsed JSON data)
     assert_equal 3,     ary.size
     assert_equal 'HUN',        ary[0]['team1']['code']
     assert_equal 'SUI',        ary[0]['team2']['code']
     assert_equal 'Matchday 1', ary[0]['round']
     # assert_equal 5,            ary[0]['score1']
     # assert_equal 0,            ary[0]['score2']
  end


  def test_todays_matches_2024_6_10
     today = Date.new( 2024, 6, 10 )
     ary = @client.todays_matches( date: today )
     ## note: returns empty array if no matches scheduled/playing today
     pp ary

     assert_equal Array, ary.class     ## for now just check return type (e.g. assume Array for parsed JSON data)
     assert              ary.empty?
  end


  def test_euro_round_1
    h = @client.round( 1 )

    pp h
=begin
{"name"=>"Matchday 1",
 "matches"=>
  [{"num"=>1,
    "date"=>"2021-06-11",
    "team1"=>{"name"=>"Turkey", "code"=>"TUR"},
    "team2"=>{"name"=>"Italy", "code"=>"ITA"},
    "score1"=>0,
    "score2"=>3,
    "score1i"=>0,
    "score2i"=>0,
    "group"=>"Group A"},
=end

    assert_equal 'GER', h['matches'][0]['team1']['code']
    assert_equal 'SCO', h['matches'][0]['team2']['code']
    # assert_equal nil,     h['matches'][0]['score1']
    # assert_equal nil,     h['matches'][0]['score2']
  end

end # class TestClientEuro2024
