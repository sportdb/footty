# footty - football.db command line client for european ("euro") championship 2024 and more

* home  :: [github.com/sportdb/footty](https://github.com/sportdb/footty)
* bugs  :: [github.com/sportdb/footty/issues](https://github.com/sportdb/footty/issues)
* gem   :: [rubygems.org/gems/footty](https://rubygems.org/gems/footty)
* rdoc  :: [rubydoc.info/gems/footty](http://rubydoc.info/gems/footty)





## Usage - Who's playing today?

The footty command line tool lets you query the online football.db HTTP JSON API services
for upcoming or past matches. For example:

    $ footty              # Defaults to today's euro 2024 matches

prints on Jun/14 2024:

    #1 Fri Jun/14            Germany (GER)    vs    Scotland (SCO)         Group A / Matchday 1
   
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

