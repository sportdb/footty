# footty - football.db command line client for world cup (russia 2018) and more

* home  :: [github.com/sportdb/footty](https://github.com/sportdb/footty)
* bugs  :: [github.com/sportdb/footty/issues](https://github.com/sportdb/footty/issues)
* gem   :: [rubygems.org/gems/footty](https://rubygems.org/gems/footty)
* rdoc  :: [rubydoc.info/gems/footty](http://rubydoc.info/gems/footty)
* forum :: [opensport](http://groups.google.com/group/opensport)





## Usage - Who's playing today?

The footty command line tool lets you query the online football.db HTTP JSON API services
for upcoming or past matches. For example:

    $ footty              # Defaults to today's world cup 2018 matches

prints on Jun/14 2018:

    #1 Thu Jun/14       Russia (RUS)  vs  Saudi Arabia (KSA) Group A  @ Luzhniki Stadium, Moscow

and the next day with `footy yesterday`:

    #1 Thu Jun/14       Russia (RUS)  5-0  Saudi Arabia (KSA) Group A  @ Luzhniki Stadium, Moscow
                     [Gazinsky 12' Cheryshev 43' Dzyuba 71' Cheryshev 90+1' Golovin 90+4']

prints on Jun/15 2018:

    #2 Fri Jun/15          Egypt (EGY)  vs        Uruguay (URU) Group A  @ Ekaterinburg Arena, Ekaterinburg
    #3 Fri Jun/15       Portugal (POR)  vs          Spain (ESP) Group B  @ Fisht Stadium, Sochi
    #4 Fri Jun/15        Morocco (MAR)  vs           Iran (IRN) Group B  @ Saint Petersburg Stadium, Saint Petersburg

and the next day with `footty y`:

    #2 Fri Jun/15          Egypt (EGY) 0-1        Uruguay (URU) Group A  @ Ekaterinburg Arena, Ekaterinburg
                     [-; Giménez 89']
    #3 Fri Jun/15       Portugal (POR) 3-3          Spain (ESP) Group B  @ Fisht Stadium, Sochi
                     [Ronaldo 4' (pen.) Ronaldo 44' Ronaldo 88'; Costa 24' Costa 55' Nacho 58']
    #4 Fri Jun/15        Morocco (MAR) 0-1           Iran (IRN) Group B  @ Saint Petersburg Stadium, Saint Petersburg
                     [-; Bouhaddouz 90+5' (o.g.)]

prints on Jun/16:

    #5 Sat Jun/16       France (FRA) vs    Australia (AUS) Group C  @ Kazan Arena, Kazan
    #6 Sat Jun/16         Peru (PER) vs      Denmark (DEN) Group C  @ Mordovia Arena, Saransk
    #7 Sat Jun/16    Argentina (ARG) vs      Iceland (ISL) Group D  @ Spartak Stadium, Moscow
    #8 Sat Jun/16      Croatia (CRO) vs      Nigeria (NGA) Group D  @ Kaliningrad Stadium, Kaliningrad

and so on.
Use `tomorrow` or `t` or `+1` to print tomorrow's matches e.g.:

    $ footty tomorrow    # -or-
    $ footty t

Use `yesterday` or `y` or `-1` to print yesterday's matches e.g.:

    $ footty yesterday    # -or-
    $ footty y

Use `upcoming` or `up` or `u` to print all upcoming matches e.g.:

    $ footty upcoming    # -or-
    $ footty up

Use `past` or `p` to print all past matches e.g.:

    $ footty past    # -or-
    $ footty p


That's it. Enjoy the beautiful game.


## Install

Just install the gem:

    $ gem install footty


## License

The `footty` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.


## Questions? Comments?

Send them along to the
[Open Sports & Friends Forum/Mailing List](http://groups.google.com/group/opensport).
Thanks!
