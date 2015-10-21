require 'spec_helper'

describe Admin::AnnouncementsController do
  describe "redirects" do
    it "redirects if not logged in on index" do
      get :index
      response.should be_redirect
    end

    it "redirects if not logged in on new" do
      get :new
      response.should be_redirect
    end

    it "redirects if not logged in on edit" do
      get :edit
      response.should be_redirect
    end

    it "redirects if not logged in on create" do
      post :create
      response.should be_redirect
    end

    it "redirects if not logged in on update" do
      put :update
      response.should be_redirect
    end

    it "redirects if not logged in on destroy" do
      delete :destroy
      response.should be_redirect
    end

    it "redirects if not admin in on new" do
      @user = FactoryGirl.create(:user)
      controller.session[:user_id] = @user.id
      get :new
      response.should be_redirect
    end

    it "redirects if not admin in on edit" do
      @user = FactoryGirl.create(:user)
      controller.session[:user_id] = @user.id
      get :edit
      response.should be_redirect
    end

    it "redirects if not admin in on create" do
      @user = FactoryGirl.create(:user)
      controller.session[:user_id] = @user.id
      post :create
      response.should be_redirect
    end

    it "redirects if not admin in on update" do
      @user = FactoryGirl.create(:user)
      controller.session[:user_id] = @user.id
      put :update
      response.should be_redirect
    end

    it "redirects if not admin in on destroy" do
      @user = FactoryGirl.create(:user)
      controller.session[:user_id] = @user.id
      delete :destroy
      response.should be_redirect
    end
  end

  describe "#index" do

    it "gets the announcements for the defined page in @announcements" do
      @user = FactoryGirl.create(:admin_user)
      controller.session[:user_id] = @user.id
      @announcement = FactoryGirl.create(:announcement)
      get :index, :page => 1
      assigns(:announcements).should eq([@announcement])
    end
  end

  describe "#new" do
    it "assigns a new announcement to @announcement" do
      @user = FactoryGirl.create(:admin_user)
      controller.session[:user_id] = @user.id
      get :new
      assigns(:announcement).class.should eq(Announcement.new.class)
    end
  end

  describe "#edit" do
    it "has @announcement" do
      @user = FactoryGirl.create(:admin_user)
      controller.session[:user_id] = @user.id
      @announcement = FactoryGirl.create(:announcement)
      get :edit, :id => @announcement.id
      assigns(:announcement).should eq(@announcement)
    end
  end

  describe "#create" do
    before :each do
      @voice = FactoryGirl.create(:non_featured_voice)
      @user = FactoryGirl.create(:admin_user)
      controller.session[:user_id] = @user.id
    end

    it "creates the new announcement in @announcement" do
      @attrs = FactoryGirl.attributes_for(:announcement)
      @attrs[:voice_id] = @voice.id
      post :create, :announcement => @attrs
      Announcement.all.count.should eq(1)
    end

    it "redirects on success" do
      @attrs = FactoryGirl.attributes_for(:announcement)
      @attrs[:voice_id] = @voice.id
      post :create, :announcement => @attrs
      response.should be_redirect
    end

    it "does not redirect if it fails" do
      @attrs = FactoryGirl.attributes_for(:announcement)
      post :create, :announcement => @attrs
      response.should_not be_redirect
    end
  end

  describe "#update" do
    before :each do
      @user = FactoryGirl.create(:admin_user)
      controller.session[:user_id] = @user.id
      @announcement = FactoryGirl.create(:announcement)
    end
    it "updates the attribuets of @announcement" do
      put :update, :id => @announcement.id, :announcement => {:title => "Hello"}
      Announcement.first.title.should eq("Hello")
    end

    it "redirects on success" do
      put :update, :id => @announcement.id, :announcement => {:title => "Hello"}
      response.should be_redirect
    end

    it "does not redirect on fail" do
      put :update, :id => @announcement.id, :announcement => {:title => ""}
      response.should_not be_redirect
    end
  end

  describe "#destroy" do
    before :each do
      @user = FactoryGirl.create(:admin_user)
      controller.session[:user_id] = @user.id
      @announcement = FactoryGirl.create(:announcement)
    end

    it "destroys the @announcement" do
      delete :destroy, :id => @announcement.id
      Announcement.all.count.should eq(0)
    end

    it "redirects on success" do
      delete :destroy, :id => @announcement.id
      response.should be_redirect
    end
  end

  describe "#find_announcement" do
    it "sets @announcement" do
      @user = FactoryGirl.create(:admin_user)
      controller.session[:user_id] = @user.id
      @announcement = FactoryGirl.create(:announcement)
      controller.params[:id] = @announcement.id
      controller.send(:find_announcement)
      assigns(:announcement).should eq(@announcement)
    end
  end
end
