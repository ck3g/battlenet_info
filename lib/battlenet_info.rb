require 'net/http'

class BattleNetInfo

	attr_reader :profile_content
	attr_reader :ladder_content

	def initialize(url)
		@profile_content = ''
		@ladder_content = ''
		@profile_url = url
		splitter = '/' unless @profile_url[-1, 1] == '/'
		@ladder_url = "#{@profile_url}#{splitter}ladder/leagues"
	end

	# <b>DEPRECATED:</b> Now calls from each method if needed
	def download_data
		warn "[DEPRECATION] `download_data` is deprecated. Now calls from each method if needed."
	end

	def valid_url?
		(@profile_url =~ /http:\/\/\w+\.battle.net\/sc2\/\w+\/profile\/\d+\/\d\/\w+/i) != nil
	end

	def server
		match_data = /http:\/\/(?<server>\w+)/i.match @profile_url
		
		match_data[:server]
	end

	def player_name
		match_data = /profile\/\d+\/\d\/(?<name>\w+)/i.match @profile_url
		
		match_data[:name]
	end

	def achievement_points
		download_profile_content if self.profile_content.empty?
		match_data = /<h3>(?<achievement_points>\d+)<\/h3>/i.match self.profile_content
		
		match_data[:achievement_points].to_i
	end

	def race
		download_profile_content if self.profile_content.empty?
		match_data = /class=\Wrace-(?<race>\w+)\W/i.match self.profile_content
		
		match_data[:race]
	end

	def stats
		download_ladder_content if self.ladder_content.empty?
		match_data = /<div\s+class=\Wtooltip-title\W>#{self.player_name}<\/div>[\n\t\s]+<strong>[\w\s]+\W<\/strong>\s*\d+<br\s*\/>[\t\n\s]+<strong>[\w\s]+\W\s*<\/strong>\s*\w+\s*<\/div>[\t\n\s]+<\/td>[\t\n\s]+<td\sclass=\Walign-center\W>(?<points>\d+)<\/td>[\t\n\s]+<td\sclass=\Walign-center\W>(?<wins>\d+)<\/td>/mi.match self.ladder_content

		return [0, 0] if match_data.nil?
		[match_data[:points].to_i, match_data[:wins].to_i]
	end

	def rank
		download_ladder_content if self.ladder_content.empty?
		match_data = /<td\s+class=\Walign-center\W\sstyle=\Wwidth:\s40px\W>(?<rank>\d+)\W*\w+<\/td>[\n\t\s]+<td>[\n\t\s]+<a\shref=\W\/sc2\/\w+\/profile\/\d+\/\d\/#{self.player_name}/mi.match self.ladder_content

		return 0 if match_data.nil?
		match_data[:rank].to_i
	end

	def league
		download_profile_content if self.profile_content.empty?
		expr = /badge-(?<league>\w+)\sbadge-medium-(?<top>\d+)\W>\s+<\/span>\s+<\/a>\s+<div\sid=\Wbest-team-1/im
		match_data = expr.match self.profile_content

		"#{match_data[:league]}_#{match_data[:top]}"
	end

	def portrait_html_style(new_path)
		download_profile_content if self.profile_content.empty?
		match_data = /<span\s+class=\Wicon-frame\s+\W[\s\t\n]+(?<picture_style>\w+\=[\w\s\W]+portraits[\w\s\W]+90px;)\W>[\t\n\s]+<\/span>/im.match self.profile_content

		match_data[:picture_style].sub('/sc2/static/local-common/images/sc2/portraits/', new_path)
	end

	private

	def download_profile_content
		@profile_content = Net::HTTP.get_response(URI.parse(@profile_url)).body if self.valid_url?
	end

	def download_ladder_content
		@ladder_content = Net::HTTP.get_response(URI.parse(@ladder_url)).body if self.valid_url?
	end

end
