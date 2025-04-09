# footty/ftty - football.db command line tool for national & int'l football club leagues (& cups) from around the world (bonus - incl. world cup, euro and more)


* home  :: [github.com/sportdb/footty](https://github.com/sportdb/footty)
* bugs  :: [github.com/sportdb/footty/issues](https://github.com/sportdb/footty/issues)
* gem   :: [rubygems.org/gems/footty](https://rubygems.org/gems/footty)
* rdoc  :: [rubydoc.info/gems/footty](http://rubydoc.info/gems/footty)





## Usage - Who's playing today?

The footty (or ftty) command line tool lets you query the online football.db via HTTP
for upcoming or past matches. For example:

    $ footty         # Defaults to today's matches of top leagues
    

prints on Sep 27, 2024:

    ==> English Premier League 2024/25
    Upcoming matches:
    Sat Sep/28 12:30   (in 1d)    Newcastle United FC    vs    Manchester City FC     Matchday 6
    Sat Sep/28 15:00   (in 1d)             Arsenal FC    vs    Leicester City FC      Matchday 6
    Sat Sep/28 15:00   (in 1d)           Brentford FC    vs    West Ham United FC     Matchday 6
    Sat Sep/28 15:00   (in 1d)             Chelsea FC    vs    Brighton & Hove Albion  Matchday 6
    Sat Sep/28 15:00   (in 1d)             Everton FC    vs    Crystal Palace FC      Matchday 6
    Sat Sep/28 15:00   (in 1d)   Nottingham Forest FC    vs    Fulham FC              Matchday 6
    Sat Sep/28 17:30   (in 1d) Wolverhampton Wanderers FC    vs    Liverpool FC           Matchday 6
    Sun Sep/29 14:00   (in 2d)        Ipswich Town FC    vs    Aston Villa FC         Matchday 6
    Sun Sep/29 16:30   (in 2d)   Manchester United FC    vs    Tottenham Hotspur FC   Matchday 6
    Mon Sep/30 20:00   (in 3d)        AFC Bournemouth    vs    Southampton FC         Matchday 6



Use `--tomorrow` or `-t` ` to print tomorrow's matches e.g.:

    $ footty --tomorrow    # -or-
    $ footty -t

Use `--yesterday` or `-y`  to print yesterday's matches e.g.:

    $ footty --yesterday    # -or-
    $ footty -y

Use `--upcoming` or `--up` or `-u` to print all upcoming matches e.g.:

    $ footty --upcoming    # -or-
    $ footty --up

Use `--past` or `-p` to print all past matches e.g.:

    $ footty --past    # -or-
    $ footty -p



That's it. Enjoy the beautiful game.


## Bonus - More Leagues & Cups  - Bundesliga, Serie A, Ligue 1, La Liga & More

Pass in the league code to display the German Bundesliga, Spanish La Liga, etc:

    $ footty de        #  who's playing in the bundesliga today?
    $ footty es        #  who's playing in la liga today?
    ...

League codes include:

- `de`  =>  Bundesliga
- `es`  =>  La Liga
- `it`  =>  Serie A
- `fr`  =>  Ligue 1
- ...

More

- `world`  =>  World Cup
- `euro`   =>  "Euro" - European Championship

See [footty/openfootball](https://github.com/sportdb/footty/blob/master/lib/footty/openfootball.rb) for the complete built-in list of data sources (and league codes).




## Trivia

Why tty? tty stands for teletype (tty) writer and is the old traditional (short) name for the unix command line.


## Install

Just install the gem:

    $ gem install footty


## License

The `footty` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.




## Questions? Comments?

Yes, you can. More than welcome.
See [Help & Support »](https://github.com/openfootball/help)

