require "rubygems"
require "battlenet_info"
require "vcr"

VCR.configure do |c|
  c.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  c.hook_into :webmock
end

describe BattleNetInfo do
  before do
    @kas_url = "http://eu.battle.net/sc2/en/profile/498165/1/EmpireKas/"
    @url_wo_slash = "http://eu.battle.net/sc2/en/profile/498165/1/EmpireKas"
    @kas = BattleNetInfo.new @kas_url

    @unexisted_url = "http://eu.battle.net/sc2/en/profile/498165/1/Unknown/"
    @unexisted = BattleNetInfo.new @unexisted_url
  end

  describe ".new" do
    it "assigns to profile_url" do
      @kas.profile_url.should eq @kas_url
    end

    context "when has trailing slash" do
      it "assigns to ladder_url" do
        @kas.ladder_url.should eq "#{@kas_url}ladder/leagues"
      end
    end

    context "when hasn't trailing slash" do
      before do
        @another_kas = BattleNetInfo.new @url_wo_slash
      end
      it "assigns to ladder url" do
        @another_kas.ladder_url.should eq "#{@url_wo_slash}/ladder/leagues"
      end
    end
  end

  describe "get content" do
    context "when profile is valid" do
      it "dont raises exceptions" do
        VCR.use_cassette("kas_profile") do
          expect { @kas.profile_content }.to_not raise_error ProfileNotFound
        end
      end
    end
  end

  describe "#valid_url?" do
    context "when valid" do
      it { @kas.valid_url?.should be_true }
    end

    context "when not valid" do
      it { BattleNetInfo.new("http://google.com").valid_url?.should be_false }
    end
  end

  describe "#server" do
    it "returns server code" do
      @kas.server.should eq "eu"
    end
  end

  describe "#player_name" do
    it "returns player's name" do
      @kas.player_name.should eq "EmpireKas"
    end
  end

  describe "#achievement_points" do
    it "returns player's achievement points" do
      VCR.use_cassette("kas_profile") do
        @kas.achievement_points.should eq 1310
      end
    end
  end

  describe "#race" do
    it "returns most played race" do
      pending "Profile page changed"
      VCR.use_cassette("kas_profile") do
        @kas.race.should eq "terran"
      end
    end
  end

  describe "#stats" do
    it "returns points and wins" do
      VCR.use_cassette("kas_ladder") do
        @kas.stats.should eq [1576, 224]
      end
    end
  end

  describe "#rank" do
    it "returns player rank" do
      VCR.use_cassette("kas_ladder") do
        @kas.rank.should eq 2
      end
    end
  end

  describe "#league" do
    it "returns player league" do
      pending "Profile page changed"
      VCR.use_cassette("kas_profile") do
        @kas.league.should eq 503
      end
    end
  end

  describe "#portrait_html_style" do
    it "returns user's pic path" do
      VCR.use_cassette("kas_profile") do

        new_path = 'new/path/to/image/'
        expected  = "style=\"background: url('#{new_path}2-90.jpg') -270px 0px no-repeat; width: 90px; height: 90px;"
        @kas.portrait_html_style(new_path).should eq expected
      end
    end
  end
end
