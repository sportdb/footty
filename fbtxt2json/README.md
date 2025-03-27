# fbtxt2json - convert football.txt match schedules & more to json


* home  :: [github.com/sportdb/footty](https://github.com/sportdb/footty)
* bugs  :: [github.com/sportdb/footty/issues](https://github.com/sportdb/footty/issues)
* gem   :: [rubygems.org/gems/fbtxt2json](https://rubygems.org/gems/fbtxt2json)
* rdoc  :: [rubydoc.info/gems/fbtxt2json](http://rubydoc.info/gems/fbtxt2json)


## Step 0 - Installation Via Gems

To install the command-line tool via gems (ruby's package manager) use:

```
$ gem install fbtxt2json
```


## Usage

Try in your shell / terminal:

```
$ fbtxt2json -h
```

resulting in:

```
Usage: fbtxt2json [options] PATH
        --verbose, --debug           turn on verbose / debug output (default: false)
    -o, --output PATH                output to file / dir
```


Note - the football.txt to .json converter works in two modes. (1) you can pass in one or more files to concat(enate) into one .json output or (2) you can pass in one or more directories to convert all files (automagically) one-by-one.



###  Concat(enate) one or more files into one .json output

Let's try to convert the "Euro" European Championship 2024
in the Football.TXT format (see [`euro/2024--germany/euro.txt`](https://github.com/openfootball/euro/blob/master/2024--germany/euro.txt)) to JSON:

```
$ fbtxt2json euro/2024--germany/euro.txt
```

resulting in:

``` json
{
  "name": "Euro 2024",
  "matches": [
    {
      "num": 1,
      "round": "Matchday 1",
      "date": "2024-06-14", "time": "21:00",
      "team1": "Germany",
      "team2": "Scotland",
      "score": { "ht": [3,0], "ft": [5,1] },
      "group": "Group A"
    },
    {
      "num": 2,
      "round": "Matchday 1",
      "date": "2024-06-15", "time": "15:00",
      "team1": "Hungary",
      "team2": "Switzerland",
      "score": { "ht": [0,2], "ft": [1,3] },
      "group": "Group A"
    },
    // ...
  ]
}
```

to output into a file use the `-o/--output` option:

```
$ fbtxt2json euro/2024--germany/euro.txt -o euro.json
```


Let's try to convert the English Premier League 2024/25
in the Football.TXT format (see [`england/2024-25/1-premierleague.txt`](https://github.com/openfootball/england/blob/master/2024-25/1-premierleague.txt)) to JSON:

```
$ fbtxt2json england/2024-25/1-premierleague.txt
```

resulting in:

``` json
{
  "name": "English Premier League 2024/25",
  "matches": [
    {
      "round": "Matchday 1",
      "date": "2024-08-16", "time": "20:00",
      "team1": "Manchester United FC",
      "team2": "Fulham FC",
      "score": { "ht": [0,0], "ft": [1,0] }
    },
    {
      "round": "Matchday 1",
      "date": "2024-08-17", "time": "12:30",
      "team1": "Ipswich Town FC",
      "team2": "Liverpool FC",
      "score": { "ht": [0,0], "ft": [0,2]}
    },
    // ...
  ]
}
```

to output into a file use the `-o/--output` option:

```
$ fbtxt2json england/2024-25/1-premierleague.txt -o en.json
```


### (Auto-)convert one or more directories

Let's try to convert the England directory (repo), that is, all datafiles
in the Football.TXT format (see [`/england`](https://github.com/openfootball/england)) to JSON:

```
$ fbtxt2json england
```

resulting in:

```
england/
   2024-25/
       1-premierleague.json
       2-championship.json
       3-league1.json
       4-league2.json
       5-nationalleague.json
       eflcup.json
       facup.json
...
```

Note - by default all `.txt` file extensions get changed to `.json`.
To use a different output directory use the `-o/--output` option. Example:

```
$ fbtxt2json england -o ./o
```

resulting in:

```
o/
  2024-25/
       1-premierleague.json
       2-championship.json
       3-league1.json
       4-league2.json
       5-nationalleague.json
       eflcup.json
       facup.json
...
...
```


That's it.




## Questions? Comments?

Yes, you can. More than welcome.
See [Help & Support »](https://github.com/openfootball/help)
