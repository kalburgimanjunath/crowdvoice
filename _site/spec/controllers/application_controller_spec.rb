require 'spec_helper'

describe ApplicationController do
  describe "#current_user" do
    it "assigns the current user to @user" do
      user = FactoryGirl.create(:user)
      session[:user_id] = user.id
      controller.current_user
      assigns(:current_user).should eq(user)
      #test
    end
  end

  describe "#find_voices" do
    before :each do
      @user = FactoryGirl.create(:user)

      @featured_voice = FactoryGirl.create(:featured_voice)
      @archived_voice = FactoryGirl.create(:archived_voice)
      @non_featured_voice = FactoryGirl.create(:non_featured_voice)
      @unapproved_voice = FactoryGirl.create(:unapproved_voice)

      controller.send(:find_voices)
    end

    it "assigns the featured voices to @featured_voices" do
      assigns(:featured_voices).should eq([@featured_voice])
    end

    it "assigns the archived voices to @archived_voices" do
      assigns(:archived_voices).should eq([@archived_voice])
    end

    it "assigns non featured voices to @non_featured_voices" do
      assigns(:non_featured_voices).should eq([@non_featured_voice])
    end

    it "assigns unapproved voices to @unapproved_voices" do
      assigns(:unapproved_voices).should eq([@unapproved_voice])
    end
  end

  describe "#get_excerpt" do
    it "creates an excerpt from the given text" do
      string = "Trim this sentence here"
      controller.send(:get_excerpt, string, 15).should eq("Trim this...")
    end
  end

  describe "#authenticate_user!" do

    controller do
      before_filter :authenticate_user!
      before_filter :find_voices, :except => [:show]
      def show
        render :text => "rendered", :status => 200
      end
    end

    it "redirects unlogged users to the login" do
      get :show, :id => 1
      response.should be_redirect
    end
    it "doesn't redirect logged users" do
      @user = FactoryGirl.create(:regular_user)
      session[:user_id] = @user.id
      get :show, :id => 1
      response.should_not be_redirect
    end
  end

  describe "#admin_required" do

    controller do
      before_filter :admin_required
      before_filter :find_voices, :except => [:show]
      def show
        render :text => "rendered", :status => 200
      end
    end

    before :each do
      @admin_user = FactoryGirl.create(:admin_user)
      @user = FactoryGirl.create(:regular_user)
    end
    it "redirects non admins to root" do
      session[:user_id] = @user.id
      get :show, :id => 1
      response.should be_redirect
    end

    it "doesn't redirect admins" do
      session[:user_id] = @admin_user.id
      get :show, :id => 1
      response.should_not be_redirect
    end
  end
end
