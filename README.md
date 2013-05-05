# Battle.Net info parser [![Build Status](https://travis-ci.org/ck3g/battlenet_info.png?branch=master)](https://travis-ci.org/ck3g/battlenet_info)
------------------------
The Battle.net Info Parser is a gem that wraps the process of retrieving in-game statistics of a
Starcraft 2 gaming account. The project is still raw so please post issues or send them to kalastiuz@gmail.com

##installation
	gem install battlenet_info

##usage

```ruby
  require 'battlenet_info'
  player = BattleNetInfo.new('http://eu.battle.net/sc2/en/profile/267901/1/Zakk/')

  # call other methods
```

##methods

```ruby
  player.valid_url?

  player.server

  player.player_name

  player.achievement_points

  player.race

  points, wins = player.stats

  player.rank

  player.league

  # combines player data to hash
  # use methods: server, player_name, achievement_points, race, points, wins, rank, league
  player.to_hash

  # returns the style attribute fragment responsible for displaying player's portrait
  # (hack for blizzard portraits as sprites)
  player.portrait_html_style(path_to_portraits_images)
```

## LICENSE

Copyright (c) 2013 Vitaly Tatarintsev

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
