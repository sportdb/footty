###
#  to run use
#     ruby test/test_client_euro2020.rb

require_relative 'helper'



class TestClientEuro2020 < Minitest::Test

  def setup
    @client = Footty::Client.new( league: 'euro', year: 2020 )
  end


  def test_getters
    today = Date.new( 2021, 6, 15 )

    todays     = @client.todays_matches( date: today )
    pp todays
    assert_equal 2,     todays.size

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


  def test_todays_matches_2021_6_15
     today = Date.new( 2021, 6, 15 )
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
     assert_equal 2,     ary.size
     assert_equal 'HUN',        ary[0]['team1']['code']
     assert_equal 'POR',        ary[0]['team2']['code']
     assert_equal 'Matchday 1', ary[0]['round']
     # assert_equal 5,            ary[0]['score1']
     # assert_equal 0,            ary[0]['score2']
  end


  def test_todays_matches_2021_6_10
     today = Date.new( 2021, 6, 10 )
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

    assert_equal 'TUR', h['matches'][0]['team1']['code']
    assert_equal 'ITA', h['matches'][0]['team2']['code']
    assert_equal 0,     h['matches'][0]['score1']
    assert_equal 3,     h['matches'][0]['score2']
  end


end # class TestClientEuro2020

__END__

GET https://raw.githubusercontent.com/openfootball/euro.json/master/2020/euro.json...
{"name"=>"Euro 2021",
 "rounds"=>
  [{"name"=>"Matchday 1",
    "matches"=>
     [{"num"=>1,
       "date"=>"2021-06-11",
       "time"=>"21:00",
       "team1"=>{"name"=>"Turkey", "code"=>"TUR"},
       "team2"=>{"name"=>"Italy", "code"=>"ITA"},
       "score"=>{"ft"=>[0, 3], "ht"=>[0, 0]},
       "goals1"=>[],
       "goals2"=>
        [{"name"=>"Demiral", "minute"=>53, "owngoal"=>true},
         {"name"=>"Immobile", "minute"=>66},
         {"name"=>"Insigne", "minute"=>79}],
       "group"=>"Group A"},
      {"num"=>2,
       "date"=>"2021-06-12",
       "time"=>"15:00",
       "team1"=>{"name"=>"Wales", "code"=>"WAL"},
       "team2"=>{"name"=>"Switzerland", "code"=>"SUI"},
       "score"=>{"ft"=>[1, 1], "ht"=>[0, 0]},
       "goals1"=>[{"name"=>"Moore", "minute"=>74}],
       "goals2"=>[{"name"=>"Embolo", "minute"=>49}],
       "group"=>"Group A"},
      {"num"=>3,
       "date"=>"2021-06-12",
       "time"=>"18:00",
       "team1"=>{"name"=>"Denmark", "code"=>"DEN"},
       "team2"=>{"name"=>"Finland", "code"=>"FIN"},
       "score"=>{"ft"=>[0, 1], "ht"=>[0, 0]},
       "goals1"=>[],
       "goals2"=>[{"name"=>"Pohjanpalo", "minute"=>60}],
       "group"=>"Group B"},