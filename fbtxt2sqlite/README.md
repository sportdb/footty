# fbtxt2sqlite - read football.txt match schedules & more into sqlite database


* home  :: [github.com/sportdb/footty](https://github.com/sportdb/footty)
* bugs  :: [github.com/sportdb/footty/issues](https://github.com/sportdb/footty/issues)
* gem   :: [rubygems.org/gems/fbtxt2sqlite](https://rubygems.org/gems/fbtxt2sqlite)
* rdoc  :: [rubydoc.info/gems/fbtxt2sqlite](http://rubydoc.info/gems/fbtxt2sqlite)


## Step 0 - Installation Via Gems

To install the command-line tool via gems (ruby's package manager) use:

```
$ gem install fbtxt2sqlite
```


## Usage

Try in your shell / terminal:

```
$ fbtxt2sqlite -h
```

resulting in:

```
Usage: fbtxt2sqlite [options] DBPATH PATH
        --verbose, --debug           turn on verbose / debug output (default: false)
        --seasons SEASONS            turn on processing only seasons listed                    
```


Let's try to read in the England directory (repo), that is, all match schedules & results
in the Football.TXT format 
(see [`/england`](https://github.com/openfootball/england)) 
that includes the Premier League, Championship, & more:

```
$ fbtxt2sqlite england.db ./england
```

resulting in an sqlite database named `./england.db` with league, team, match, & more records.



That's it.



## Questions? Comments?

Yes, you can. More than welcome.
See [Help & Support »](https://github.com/openfootball/help)
