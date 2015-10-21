require 'spec_helper'

describe Voice do
  before(:all) do
    @voice = FactoryGirl.create(:voice)
  end

  it { should belong_to(:user) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it "should have theme" do
    @voice.theme.should == "blue"
  end
  it "should have a valid rss feed" do
    @voice.should be_valid
  end
  it "should evaluate square background type" do
    @voice.square_version?.should == true
  end
  it "should evaluate wide background type" do
    voice = FactoryGirl.create(:voice_wide)
    voice.wide_version?.should == true
  end
  it "should evaluate none background type" do
    voice = FactoryGirl.create(:voice_none)
    voice.none_version?.should == true
  end
  it "generates slug based on title" do
    voice = FactoryGirl.create(:voice, :title => "Testing-slug-123")
    voice.slug.should == 'testing-slug-123'
  end
  it "allows value for theme with predefined themes" do
    Voice::THEMES.each do |theme|
      should allow_value(theme).for(:theme)
    end
  end
  it "doesn't allow value for theme that is not a predefine theme" do
    %w[gray cyan black white purple].each do |theme|
      should_not allow_value(theme).for(:theme)
    end
  end
  it 'should add rss content after save' do
    @voice.rss_feed = nil
    @voice.posts = []
    @voice.save
    @voice.rss_feed = "http://www.pablasso.com/category/windows/feed"
    @voice.save
    @voice.reload
    @voice.posts.should_not be_empty
  end
  it 'should add twitter links after save' do
    @voice.twitter_search = nil
    @voice.save
    @voice.twitter_search = "#google"
    @voice.posts = []
    @voice.save
    @voice.reload
    @voice.posts.should_not be_empty
  end
  

end
