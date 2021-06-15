# footty - football.db command line client for european ("euro") championship 2020 (in 2021) and more

* home  :: [github.com/sportdb/footty](https://github.com/sportdb/footty)
* bugs  :: [github.com/sportdb/footty/issues](https://github.com/sportdb/footty/issues)
* gem   :: [rubygems.org/gems/footty](https://rubygems.org/gems/footty)
* rdoc  :: [rubydoc.info/gems/footty](http://rubydoc.info/gems/footty)
* forum :: [opensport](http://groups.google.com/group/opensport)





## Usage - Who's playing today?

The footty command line tool lets you query the online football.db HTTP JSON API services
for upcoming or past matches. For example:

    $ footty              # Defaults to today's euro 2020 (in 2021) matches

prints on Jun/14 2021:

    #20 Mon Jun/14         Scotland (SCO)   vs   Czech Republic (CZE)   Group D / Matchday 1
    #25 Mon Jun/14           Poland (POL)   vs   Slovakia (SVK)         Group E / Matchday 1
    #26 Mon Jun/14            Spain (ESP)   vs   Sweden (SWE)           Group E / Matchday 1

and the next day with `footty yesterday`:

    #20 Mon Jun/14         Scotland (SCO) 0-2 (0-1) Czech Republic (CZE)   Group D / Matchday 1
    #25 Mon Jun/14           Poland (POL) 1-2 (0-1) Slovakia (SVK)         Group E / Matchday 1
    #26 Mon Jun/14            Spain (ESP) 0-0       Sweden (SWE)           Group E / Matchday 1

prints on Jun/15 2021:

    #31 Tue Jun/15          Hungary (HUN)    vs    Portugal (POR)         Group F / Matchday 1
    #32 Tue Jun/15           France (FRA)    vs    Germany (GER)          Group F / Matchday 1

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




## Trivia

Why tty? tty stands for teletype (tty) writer and is the old traditional (short) name for the unix command line.


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
