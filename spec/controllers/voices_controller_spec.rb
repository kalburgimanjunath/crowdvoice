require 'spec_helper'

describe VoicesController do
  describe "#index" do
    it "redirects to admin_voices" do
      get :index
      response.should redirect_to(admin_voices_path)
    end
  end

  describe "#show" do
    before :each do
      @voice = FactoryGirl.create(:non_featured_voice)
      @unapproved_post = FactoryGirl.build(:unapproved_post, :voice => @voice)
      @approved_post = FactoryGirl.build(:approved_post, :voice => @voice)
      @approved_post2 = FactoryGirl.build(:approved_post, :voice => @voice)

      @user = FactoryGirl.create(:user)
      controller.session[:user_id] = @user.id

      @vote1 = FactoryGirl.create(:vote, :post => @approved_post, :user => @user)
      @vote2 = FactoryGirl.create(:vote, :post => @approved_post2, :user => @user)
      @vote3 = FactoryGirl.create(:negative_vote, :post => @unapproved_post, :user => @user)
    end

    it "assigns @voice by the slug" do
      get :show, :id => @voice.slug
      assigns(:voice).should eq(@voice)
    end

    it "assigns unapproved posts to @posts if mod" do
      get :show, :id => @voice.slug, :mod => true
      assigns(:posts).should eq([@unapproved_post])
    end

    it "assigns approved posts to @posts if not mod" do
      get :show, :id => @voice.slug, :mod => false
      assigns(:posts).should eq([@approved_post2, @approved_post])
    end

    it "assigns the @next_page if html" do
      page_number = 2
      get :show, :id => @voice.slug, :mod => false, :page => page_number, :format => :html
      assigns(:next_page).should eq(page_number+1)
    end

    it "assigns the @next_page if js" do
      page_number = 2
      get :show, :id => @voice.slug, :mod => false, :page => page_number, :format => :js
      assigns(:next_page).should eq(page_number+1)
    end

    it "assigns @posts_count if html" do
      get :show, :id => @voice.slug, :mod => false, :format => :html
      assigns(:posts_count).should eq([@approved_post, @approved_post2].count)
    end

    it "assigns @posts_count if js" do
      get :show, :id => @voice.slug, :mod => false, :format => :js
      assigns(:posts_count).should eq([@approved_post, @approved_post2].count)
    end

    it "assigns @votes if html" do

      result = [{"id" => @approved_post.id.to_s, "positive" => true}, {"id" => @approved_post2.id.to_s, "positive" => true}]

      get :show, :id => @voice.slug, :mod => false, :format => :html

      assigns(:votes).should eq(result)
    end

    it "assigns @twitter if html and voice has twitter search" do
      @voice.twitter_search = "bzfxhmfxhm"
      @voice.save
      get :show, :id => @voice.slug, :mod => false, :format => :html
      assigns(:twitter).should eq(TwitterSearch.search(@voice.twitter_search))
    end

    it "does not assign @twitter if voice doesn't have twitter_search" do
      get :show, :id => @voice.slug, :mod => false, :format => :html
      assigns(:twitter).should eq(nil)
    end

    it "assigns @timeline from the posts grouped by year" do
      @approved_post2.created_at = 2.years.ago
      @approved_post2.save
      get :show, :id => @voice.slug, :mod => false, :format => :html
      assigns(:timeline).should eq({@approved_post.created_at.year => [@approved_post.created_at.beginning_of_day.to_date], @approved_post2.created_at.year => [@approved_post2.created_at.beginning_of_day.to_date]})
    end

    it "includes params[:post] in @posts if present" do
      get :show, :id => @voice.slug, :mod => false, :post => @unapproved_post.id, :format => :html
      assigns(:posts).should include(@unapproved_post)
    end
  end

  describe "#fetch_feeds" do
    it "enqueues an RssFeedJob" do
      get :fetch_feeds
      Delayed::Job.count.should eq(1)
    end

    it "redirects to index" do
      get :fetch_feeds
      response.should redirect_to(:action => 'index')
    end
  end

  describe "#locations" do
    it "defines voices in json with all the voices with locations" do
      @location_voice = FactoryGirl.create(:voice, :latitude => "1", :longitude => "1", :location => "This place")
      get :locations, :format => :json
      voice_struct = [{:slug => @location_voice.slug, :title => @location_voice.title, :latitude => @location_voice.latitude, :longitude => @location_voice.longitude}]
      response_struct = [{:location => "This place", :voices => voice_struct}]
      response.body.should eq(response_struct.to_json)
    end
  end
end
