require 'spec_helper'

describe PostsController do
  describe "#create" do
    before :each do
      @voice = FactoryGirl.create(:non_featured_voice)
      @attrs = FactoryGirl.attributes_for(:post)
    end
    it "should set the voice in @voice" do
      post :create, :voice_id => @voice.slug, :post => @attrs
      assigns(:voice).should eq(@voice)
    end

    it "creates a new post in @post if valid" do
      post :create, :voice_id => @voice.slug, :post => @attrs
      Post.all.count.should eq(1)
    end

    it "sends OK if post is valid" do
      xhr :post, :create, :format => :json, :voice_id => @voice.slug, :post => @attrs
      response.response_code.should eq(200)
    end

    it "sends unprocessable entity if post is invalid" do
      xhr :post, :create, :format => :json, :voice_id => @voice.slug, :post => nil
      response.response_code.should eq(422)
    end
  end

  describe "#show" do
    it "assigns the requested post to @post" do
      @voice = FactoryGirl.create(:non_featured_voice) do |voice|
        voice.posts.create(FactoryGirl.attributes_for(:post))
      end
      get :show, :voice_id => @voice.slug, :id => @voice.posts.first.id
      assigns(:post).should eq(@voice.posts.first)
    end
  end

  describe "#remote_page_info" do
    it "returns an error on invalid urls" do
      get :remote_page_info, :url => "invalidurl"
      response.body.should eq({:error => I18n.t('flash.posts.embedly_time_out')}.to_json)
    end

    it "gets the url info" do
      get :remote_page_info, :url => "http://isitchristmas.com"
      response.body.should eq({:title => "Is it Christmas?", :description => "", :images => ["https://s3.amazonaws.com/crowdvoice-production/link-default.png"]}.to_json)
    end

    it "returns empty JSON if no url was sent" do
      get :remote_page_info
      response.body.should eq({}.to_json)
    end
  end

  describe "#destroy" do
    before :each do
      @voice = FactoryGirl.create(:non_featured_voice) do |voice|
        voice.posts.create(FactoryGirl.attributes_for(:post))
      end
    end

    it "destroys the user" do
      delete :destroy, :id => @voice.posts.first.id
      Post.all.count.should eq(0)
    end

    it "redirects to the voice" do
      delete :destroy, :id => @voice.posts.first.id
      response.should redirect_to(voice_path(@voice))
    end
  end

  describe "#notify_js_error" do
    it "raises an exception" do
      lambda { get :notify_js_error }.should raise_error
    end
  end

  describe "find_voice" do
    it "assigns a voice to @voice, via the :voice_id param" do
      @voice = FactoryGirl.create(:non_featured_voice)
      controller.params = {:voice_id => @voice.slug}
      controller.send(:find_voice)
      assigns(:voice).should eq(@voice)
    end
  end
end
