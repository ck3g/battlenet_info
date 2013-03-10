# Battle.Net info parser [![Build Status](https://travis-ci.org/ck3g/battlenet_info.png?branch=master)](https://travis-ci.org/ck3g/battlenet_info)
------------------------
The Battle.net Info Parser is a gem that wraps the process of retrieving in-game statistics of a
Starcraft 2 gaming account. The project is still raw so please post issues or send them to kalastiuz@gmail.com

##installation
	gem install battlenet_info

##usage
	require 'battlenet_info'
	player = BattleNetInfo.new('http://eu.battle.net/sc2/en/profile/267901/1/Zakk/')

	# call other methods

##methods
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

