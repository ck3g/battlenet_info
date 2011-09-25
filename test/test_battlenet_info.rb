require 'test/unit'
require 'battlenet_info'

class BattleNetInfoTest < Test::Unit::TestCase

	def setup

		@infos = Array.new
		@infos << BattleNetInfo.new('http://eu.battle.net/sc2/en/profile/267901/1/Zakk/')
		@infos << BattleNetInfo.new('http://eu.battle.net/sc2/en/profile/484961/1/imbaStrelok/')
		@infos << BattleNetInfo.new('http://kr.battle.net/sc2/ko/profile/275670/1/SilentWeRRa/')
		@infos << BattleNetInfo.new('http://eu.battle.net/sc2/en/profile/498165/1/EmpireKas/')
		@infos << BattleNetInfo.new('http://eu.battle.net/sc2/en/profile/174572/1/mTwDIMAGA/')

		@invalid_infos = Array.new
		@invalid_infos << BattleNetInfo.new('')
		@invalid_infos << BattleNetInfo.new('http://google.com')
		@invalid_infos << BattleNetInfo.new('')
		@invalid_infos << BattleNetInfo.new('http://eu.battle.net/sc2/en/profile/1/Zakk/')
		@invalid_infos << BattleNetInfo.new('http://eu.battle.net/sc2/en/profile/484961/1')

		@zakk = BattleNetInfo.new('http://eu.battle.net/sc2/en/profile/267901/1/Zakk/')
		@strelok = BattleNetInfo.new('http://eu.battle.net/sc2/en/profile/484961/1/imbaStrelok/')
		@silent = BattleNetInfo.new('http://kr.battle.net/sc2/ko/profile/275670/1/SilentWeRRa/')
		@kas = BattleNetInfo.new('http://eu.battle.net/sc2/en/profile/498165/1/EmpireKas/')
		@dimaga = BattleNetInfo.new('http://eu.battle.net/sc2/en/profile/174572/1/mTwDIMAGA/')
	end

	def test_initializing_new_object
		@infos.each do |info| 
			assert info.instance_of? BattleNetInfo
		end
	end

	def test_valid_profile_url
		@infos.each do |info|
			assert info.valid_url?
		end
	end

	def test_invalid_profile_url
		@invalid_infos.each do |info|
			assert_equal false, info.valid_url?
		end
	end

	def test_get_profile_server
		assert_equal 'eu', @zakk.server
		assert_equal 'kr', @silent.server

		assert_not_equal '', @zakk.server
		assert_not_equal 'kr', @zakk.server
		assert_not_equal 'eu', @silent.server
	end

	def test_get_player_name
		assert_equal 'Zakk', @zakk.player_name
		assert_equal 'imbaStrelok', @strelok.player_name
		assert_equal 'SilentWeRRa', @silent.player_name 
		assert_equal 'EmpireKas', @kas.player_name
		assert_equal 'mTwDIMAGA', @dimaga.player_name

	end

	def test_getting_achievement_points
		@zakk.download_data
		assert_equal 2450, @zakk.achievement_points

		@strelok.download_data
		assert_equal 930, @strelok.achievement_points

		@silent.download_data
		assert_equal 3630, @silent.achievement_points

		@kas.download_data
		assert_equal 1150, @kas.achievement_points

		@dimaga.download_data
		assert_equal 605, @dimaga.achievement_points
	end

	def test_getting_player_prefered_race
		@zakk.download_data
		assert_equal 'terran', @zakk.race

		@strelok.download_data
		assert_equal 'terran', @strelok.race

		@silent.download_data
		assert_equal 'random', @silent.race

		zero = BattleNetInfo.new 'http://eu.battle.net/sc2/en/profile/178390/1/Zero/'
		zero.download_data
		assert_equal 'protoss', zero.race

		@dimaga.download_data
		assert_equal 'zerg', @dimaga.race
	end

	def test_getting_player_league
		
		@zakk.download_data
		assert_equal 'platinum_1', @zakk.league

		@strelok.download_data
		assert_equal 'grandmaster_1', @strelok.league

		neo = BattleNetInfo.new 'http://kr.battle.net/sc2/ko/profile/332012/1/NeoFantasy/'
		neo.download_data
		assert_equal 'platinum_2', neo.league

		zero = BattleNetInfo.new 'http://eu.battle.net/sc2/en/profile/178390/1/Zero/'
		zero.download_data
		assert_equal 'grandmaster_4', zero.league

		@dimaga.download_data
		assert_equal 'grandmaster_3', @dimaga.league
	end

	def test_getting_player_rank
		@zakk.download_data
		assert_equal 70, @zakk.rank

		@strelok.download_data
		assert_equal 132, @strelok.rank

		@silent.download_data
		assert_equal 0, @silent.rank

		@kas.download_data
		assert_equal 13, @kas.rank

		@dimaga.download_data
		assert_equal 26, @dimaga.rank
	end

	def test_getting_player_stats
		@zakk.download_data
		points, wins = @zakk.stats
		assert_equal 30, points
		assert_equal 2, wins

		@strelok.download_data
		points, wins = @strelok.stats
		assert_equal 918, points
		assert_equal 77, wins

		@silent.download_data
		points, wins = @silent.stats
		assert_equal 0, points
		assert_equal 0, wins

		@kas.download_data
		points, wins = @kas.stats
		assert_equal 1176, points
		assert_equal 823, wins

		@dimaga.download_data
		points, wins = @dimaga.stats
		assert_equal 1105, points
		assert_equal 150, wins

	end

	def test_getting_user_pic_path
		@zakk.download_data
		new_path = 'new/path/to/image/'
		expected  = "style=\"background: url('#{new_path}0-90.jpg?v30') -450px -90px no-repeat; width: 90px; height: 90px;"
		assert_equal expected, @zakk.portrait_html_style(new_path)
	end

end
