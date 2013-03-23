require 'net/http'
require "nokogiri"
require 'exceptions.rb'

class BattleNetInfo

  EXCEPTION_MESSAGE = 'Profile not found or Battle.Net temporary unavailable'

  attr_reader :profile_url, :ladder_url

  def initialize(url)
    @profile_url = url
    splitter = '/' unless @profile_url[-1, 1] == '/'
    @ladder_url = "#{@profile_url}#{splitter}ladder/leagues"
  end

  def profile_content
    @profile_content ||= download_profile_content
  end

  def ladder_content
    @ladder_content ||= download_ladder_content
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
    match_data = /<h3>(?<achievement_points>\d+)<\/h3>/i.match self.profile_content

    match_data[:achievement_points].to_i
  end

  def race
    raise RaceTemporaryUnvailable
    match_data = /class=\Wrace-(?<race>\w+)\W/i.match self.profile_content

    match_data[:race]
  end

  # TODO: calculate loses again
  def stats
    match_data = /<div\s+class=\Wtooltip-title\W>#{self.player_name}<\/div>[\n\t\s]+<strong>[\w\s]+\W<\/strong>\s*\d+<br\s*\/>[\t\n\s]+<strong>[\w\s]+\W\s*<\/strong>\s*\w+\s*<\/div>[\t\n\s]+<\/td>[\t\n\s]+<td\sclass=\Walign-center\W>(?<points>\d+)<\/td>[\t\n\s]+<td\sclass=\Walign-center\W>(?<wins>\d+)<\/td>/mi.match self.ladder_content

    return [0, 0] if match_data.nil?
    [match_data[:points].to_i, match_data[:wins].to_i]
  end

  def rank
    match_data = /<td\s+class=\Walign-center\W\sstyle=\Wwidth:\s40px\W>(?<rank>\d+)\W*\w+<\/td>[\n\t\s]+<td>[\n\t\s]+<a\shref=\W\/sc2\/\w+\/profile\/\d+\/\d\/#{self.player_name}/mi.match self.ladder_content

    return 0 if match_data.nil?
    match_data[:rank].to_i
  end

  def league
    html_doc = Nokogiri::HTML(profile_content)
    badge_data = html_doc.at_css("#season-snapshot").children.css(".badge-item").first.at_css("span.badge")[:class]
    match_data = /badge-(?<league>\w+)\sbadge-medium-(?<top>\d+)/.match badge_data

    "#{match_data[:league]}_#{match_data[:top]}"
  end

  def portrait_html_style(new_path)
    match_data = /<span\s+class=\Wicon-frame\s+\W[\s\t\n]+(?<picture_style>\w+\=[\w\s\W]+portraits[\w\s\W]+90px;)\W>[\t\n\s]+<\/span>/im.match self.profile_content

    match_data[:picture_style].sub('http://media.blizzard.com/sc2/portraits/', new_path).sub("style\=\"", "")
  end

  def to_hash
    points, wins = self.stats

    player_data = {
      :server => self.server,
      :player_name => self.player_name,
      :achievement_points => self.achievement_points,
      # :race => self.race,
      :points => points,
      :wins => wins,
      :rank => self.rank,
      :league => self.league
    }
  end

  private

  def download_profile_content
    @profile_content = get_content(@profile_url)
  end

  def download_ladder_content
    @ladder_content = get_content(@ladder_url)
  end

  def get_content(url)
    response = Net::HTTP.get_response(URI.parse(url)) if self.valid_url?
    raise ProfileNotFound.new(EXCEPTION_MESSAGE) unless response.is_a? Net::HTTPOK
    response.body
  end

end
