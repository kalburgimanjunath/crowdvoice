require 'spec_helper'

describe WidgetController do
  describe "#show" do
    before :each do
      @voice = FactoryGirl.create(:unapproved_voice)
    end
    it "finds @voice by slug if scope is not all" do
      get :show, :id => @voice.slug
      assigns(:voice).should eq(@voice)
    end

    it "puts the approved 50 posts for @voice in @posts if scope is not all" do
      included_posts = []
      limit = 3
      (limit+1).times do
        included_posts << FactoryGirl.create(:approved_post, :voice => @voice)
      end

      get :show, :id => @voice.slug, :limit => limit

      assigns(:posts).should eq(included_posts.reverse[0,limit])
    end

    it "finds all approved voices in @voices if scope is all" do
      @featured_voice = FactoryGirl.create(:featured_voice)
      get :show, :id => @voice.slug, :scope => 'all'
      assigns(:voices).should eq([@featured_voice])
    end

    it "sets rtl to true if rtl is 1" do
      get :show, :id => @voice.slug, :scope => 'all', :rtl => '1'
      assigns(:rtl).should eq(true)
    end

    it "defaults rtl to false" do
      get :show, :id => @voice.slug, :scope => 'all'
      assigns(:rtl).should eq(false)
    end
  end

  describe "#get_size_params" do
    before :each do
      controller.params[:size] = 'small'
      controller.params[:width] = 'small'
    end
    it "stores the size class in @list_height_size" do
      controller.send(:get_size_params)
      assigns(:list_height_size).should_not eq(nil)
    end

    it "sets the @post_image_size" do
      controller.send(:get_size_params)
      assigns(:post_image_size).should_not eq(nil)
    end

    it "sets the @voice_image_size" do
      controller.send(:get_size_params)
      assigns(:voice_image_size).should_not eq(nil)
    end

    it "sets the @list_width_size" do
      controller.send(:get_size_params)
      assigns(:list_width_size).should_not eq(nil)
    end

    it "sets @show_description to true if show_description param is 1" do
      controller.params[:show_description] = "1"
      controller.send(:get_size_params)
      assigns(:show_description).should eq(true)
    end

    it "defaults @show_description to false" do
      controller.send(:get_size_params)
      assigns(:show_description).should eq(false)
    end
  end
end
