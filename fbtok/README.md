# fbtok - football.txt lint tools incl. tokenizer (lexer), parser & more



* home  :: [github.com/sportdb/footty](https://github.com/sportdb/footty)
* bugs  :: [github.com/sportdb/footty/issues](https://github.com/sportdb/footty/issues)
* gem   :: [rubygems.org/gems/fbtok](https://rubygems.org/gems/fbtok)
* rdoc  :: [rubydoc.info/gems/fbtok](http://rubydoc.info/gems/fbtok)


## Step 0 - Installation Via Gems

To install the command-line tool via gems (ruby's package manager) use:

```
$ gem install fbtok
```


## Usage


### fbtok & fbtree -  use tokenizer (lexer) & parser

- depends on sportdb-parser

get help
```
$ fbtok -h
$ fbtree -h
```

run on single / individual (data)files
````
$ fbtok england/2025-26/1-permierleague.txt
$ fbtok worldcup/min/2022.txt

$ fbtree england/2025-26/1-permierleague.txt
$ fbtree worldcup/min/2022.txt

```

or on directories (auto-collecting all datafiles)

$ fbtok england
$ fbtok worldcup

$ fbtree england
$ fbtree worldcup
```



### fbquick/fbquik & fbx   -  use quick match reader & dump match schedule

- depends on sportdb-quick (& sportdb-parser)

get help
```
$ fbquik -h
$ fbx -h
```

run on single / individual (data)files
````
$ fbquik england/2025-26/1-permierleague.txt
$ fbquik worldcup/min/2022.txt

$ fbx england/2025-26/1-permierleague.txt
$ fbx worldcup/min/2022.txt
```

or on directories (auto-collecting all datafiles)

$ fbquik england
$ fbquik worldcup
```

note: `fbx` only works with single / individual (data)files






## Questions? Comments?

Yes, you can. More than welcome.
See [Help & Support »](https://github.com/openfootball/help)
