#Battle.Net info parser
	Parses StarCraft2 player info

#using
		player = BattleNetInfo.new('http://eu.battle.net/sc2/en/profile/267901/1/Zakk/')
		player.download_data

		# call other methods

#methods list
		player.valid_url?

		player.server

		player.player_name

		player.achievement_points

		player.race

		points, wins = player.stats

		player.rank

		player.league

		player.portrait_html_style(path_to_portraits_images) # gets html style attribute for display user pics
		
