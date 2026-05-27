# fbtxt2json (& fbtxt2csv) - convert football.txt match schedules & more to (structured) json or (tabular) csv


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
Usage: fbtxt2json [options] DATAFILES or DIRS
        --verbose, --debug           turn on verbose / debug output (default: false)
    -o, --output PATH                output to file / dir
        --seasons SEASONS            turn on processing only seasons (default: false)
```


Note - the football.txt to .json converter works in two modes.

(i) you can pass in one or more (match data) files to concat(enate) into one .json output or <br>
(ii) you can pass in one or more directories to convert all (match data) files (automagically) one-by-one.




###  Concat(enate) one or more (match data) files into one .json output

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
      "round": "Matchday 1",
      "date": "2024-06-14", "time": "21:00",
      "team1": "Germany",
      "team2": "Scotland",
      "score": { "ht": [3,0], "ft": [5,1] },
      "group": "Group A"
    },
    {
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


Note - by default all `.txt` file extensions get changed to `.json` (if the include a season in the basename or the dirname).
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





## Bonus -  fbtxt2csv - convert football.txt (match data) files to the (tabular) comma-separated values (.csv) format


Try in your shell / terminal:

```
$ fbtxt2csv -h
```

resulting in:

```
Usage: fbtxt2csv [options] DATAFILES and/or DIRS
        --verbose, --debug           turn on verbose / debug output (default: false)
    -o, --output PATH                output to file
        --seasons SEASONS            turn on processing only seasons (default: false)
```

Let's try to convert the "Euro" European Championship 2024
in the Football.TXT format (see [`euro/2024--germany/euro.txt`](https://github.com/openfootball/euro/blob/master/2024--germany/euro.txt)) to CSV:


```
$ fbtxt2csv euro/2024--germany/euro.txt -o euro2024.csv
```

resulting in:

``` csv
League,Date,Time,Team 1,Team 2,Score,HT,FT,ET,P,Round,Ground
Euro 2024,2024-06-14,21:00,Germany,Scotland,,3-0,5-1,,,"Group A, Matchday 1",München
Euro 2024,2024-06-15,15:00,Hungary,Switzerland,,0-2,1-3,,,"Group A, Matchday 1",Köln
Euro 2024,2024-06-19,18:00,Germany,Hungary,,1-0,2-0,,,"Group A, Matchday 2",Stuttgart
Euro 2024,2024-06-19,21:00,Scotland,Switzerland,,1-1,1-1,,,"Group A, Matchday 2",Köln
Euro 2024,2024-06-23,21:00,Switzerland,Germany,,1-0,1-1,,,"Group A, Matchday 3",Frankfurt
Euro 2024,2024-06-23,21:00,Scotland,Hungary,,0-0,0-1,,,"Group A, Matchday 3",Stuttgart
Euro 2024,2024-06-15,18:00,Spain,Croatia,,3-0,3-0,,,"Group B, Matchday 1",Berlin
Euro 2024,2024-06-15,21:00,Italy,Albania,,2-1,2-1,,,"Group B, Matchday 1",Dortmund
Euro 2024,2024-06-19,15:00,Croatia,Albania,,0-1,2-2,,,"Group B, Matchday 2",Hamburg
Euro 2024,2024-06-20,21:00,Spain,Italy,,0-0,1-0,,,"Group B, Matchday 2",Gelsenkirchen
Euro 2024,2024-06-24,21:00,Albania,Spain,,0-1,0-1,,,"Group B, Matchday 3",Düsseldorf
Euro 2024,2024-06-24,21:00,Croatia,Italy,,0-0,1-1,,,"Group B, Matchday 3",Leipzig
...
```

or pass in the directory and get all (match data) files rolled-into-one tabular .csv file.
Try:

```
$ fbtxt2csv euro -o euro.csv
```

resulting in:

``` csv
League,Date,Time,Team 1,Team 2,Score,HT,FT,ET,P,Round,Ground
Euro 1960,1960-07-06,20:00,France,Yugoslavia,4-5,,,,,Semi-finals,"Parc des Princes, Paris"
Euro 1960,1960-07-06,20:30,Czechoslovakia,Soviet Union,0-3,,,,,Semi-finals,"Stade Vélodrome, Marseille"
Euro 1960,1960-07-09,21:30,Czechoslovakia,France,2-0,,,,,Third place play-off,"Stade Vélodrome, Marseille"
Euro 1960,1960-07-10,20:30,Soviet Union,Yugoslavia,,,,2-1,,Final,"Parc des Princes, Paris"
Euro 1964,1964-06-17,20:00,Spain,Hungary,,,,2-1,,Semi-finals,"Santiago Bernabéu, Madrid"
Euro 1964,1964-06-17,22:30,Denmark,Soviet Union,0-3,,,,,Semi-finals,"Camp Nou, Barcelona"
Euro 1964,1964-06-20,20:00,Hungary,Denmark,,,,3-1,,Third place play-off,"Camp Nou, Barcelona"
Euro 1964,1964-06-21,18:30,Spain,Soviet Union,2-1,,,,,Final,"Santiago Bernabéu, Madrid"
Euro 1968,1968-06-05,18:00,Italy,Soviet Union,,,,0-0,,Semi-finals,"Stadio San Paolo, Naples"
Euro 1968,1968-06-05,21:15,Yugoslavia,England,1-0,,,,,Semi-finals,"Stadio Comunale, Florence"
Euro 1968,1968-06-08,15:00,England,Soviet Union,2-0,,,,,Third place play-off,"Stadio Olimpico, Rome"
Euro 1968,1968-06-08,21:15,Italy,Yugoslavia,,,,1-1,,Final,"Stadio Olimpico, Rome"
Euro 1968,1968-06-10,21:15,Italy,Yugoslavia,2-0,,,,,"Final, Replay","Stadio Olimpico, Rome"
Euro 1972,1972-06-14,20:00,West Germany,Belgium,2-1,,,,,Semi-finals,"Antwerpen, Bosuil"
Euro 1972,1972-06-14,20:00,Soviet Union,Hungary,1-0,,,,,Semi-finals,"Brussel, Astridpark"
Euro 1972,1972-06-17,20:00,Belgium,Hungary,2-1,,,,,Third place play-off,"Liège, Stade Sclessin"
Euro 1972,1972-06-18,16:00,West Germany,Soviet Union,3-0,,,,,Final,"Bruxelles, Stade Heysel"
...
```




## Questions? Comments?

Yes, you can. More than welcome.
See [Help & Support »](https://github.com/openfootball/help)
