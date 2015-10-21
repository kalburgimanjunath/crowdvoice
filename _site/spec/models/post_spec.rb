require 'spec_helper'

describe Post do
  before(:all) do
    @post = FactoryGirl.create(:post)
  end
  it { should belong_to(:voice) }
  it { should belong_to(:user) }
  it { should belong_to(:user) }
  it { should validate_uniqueness_of(:source_url) }
  it { should validate_presence_of(:source_url) }
  it { should validate_presence_of(:source_type) }
  it "it should retun flickr with a flickr photo" do
    post = FactoryGirl.create(:flickr_post)
    post.source_service.should == "flickr"
  end
  it "it should retun twitpic with a twitpic photo" do
    post = FactoryGirl.create(:twitpic_post)
    post.source_service.should == "twitpic"
  end
  it "it should retun yfrog with a yfrog photo" do
    post = FactoryGirl.create(:yfrog_post)
    post.source_service.should == "yfrog"
  end
  it "it should retun youtube with a youtube video" do
    post = FactoryGirl.create(:youtube_post)
    post.source_service.should == "youtube"
  end
  it "it should retun vimeo with a vimeo video" do
    post = FactoryGirl.create(:vimeo_post)
    post.source_service.should == "vimeo"
  end
  it "it should retun link with a common link" do
    @post.source_service.should == "link"
  end
  it "should have empty url_check" do
    @post.url_check.should == nil
  end
  it "should not have empty title" do
    @post.title.should_not be nil
  end
  it "should not have empty description" do
    @post.description.should_not be nil
  end
  it "should set scraped title" do
    @post.title.should == "Annan: If observers fail, Syria could plunge into civil war - CNN.com"
  end
  it "should set scraped description" do
    @post.description.should == "Special envoy Kofi Annan said Tuesday that observers were the last hope for Syria. Otherwise the nation is sure to plunge into civil war."
  end
  it "should set scraped remote_url" do
    @post.remote_image_url.should == "http://i.cdn.turner.com/cnn/images/1.gif"
  end
end
