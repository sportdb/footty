###
#  to run use
#     $ ruby test/test_worldcup.rb

require_relative 'helper'



class TestWorldCup < Minitest::Test

  def setup
    @dataset = Footty::OpenfootballDataset.new( league: 'world', season: '2018' )
  end


  def test_getters
    today = Date.new( 2018, 6, 16 )

    todays     = @dataset.todays_matches( date: today )
    pp todays
    assert_equal 4,     todays.size

    yesterdays = @dataset.yesterdays_matches( date: today )
    pp yesterdays
    assert_equal 3,     yesterdays.size

    tomorrows  = @dataset.tomorrows_matches( date: today )
    pp tomorrows
    assert_equal 3,     tomorrows.size

    past     = @dataset.past_matches( date: today )
    pp past

    upcoming = @dataset.upcoming_matches( date: today )
    pp upcoming
  end



  def test_todays_matches_2018_6_14
     today = Date.new( 2018, 6, 14 )
     ary = @dataset.todays_matches( date: today )
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
     ## assert_equal 'RUS',        ary[0]['team1']['code']
     ## assert_equal 'KSA',        ary[0]['team2']['code']
     assert_equal 'Matchday 1', ary[0]['round']
     ## assert_equal 5,            ary[0]['score1']
     ## assert_equal 0,            ary[0]['score2']
  end

  def test_todays_matches_2018_6_10
     today = Date.new( 2018, 6, 10 )
     ary = @dataset.todays_matches( date: today )
     ## note: returns empty array if no matches scheduled/playing today
     pp ary

     assert_equal Array, ary.class     ## for now just check return type (e.g. assume Array for parsed JSON data)
     assert              ary.empty?
  end



end # class TestWorldCup
