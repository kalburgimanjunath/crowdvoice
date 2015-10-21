require 'spec_helper'

describe Admin::SettingsController do
  describe "redirects" do
    it "redirects if not logged in on index" do
      get :index
      response.should be_redirect
    end

    it "redirects if not logged in on update" do
      put :update
      response.should be_redirect
    end

    it "redirects if not admin in on index" do
      @user = FactoryGirl.create(:user)
      controller.session[:user_id] = @user.id
      get :index
      response.should be_redirect
    end

    it "redirects if not admin in on update" do
      @user = FactoryGirl.create(:user)
      controller.session[:user_id] = @user.id
      put :update
      response.should be_redirect
    end
  end

  describe "#index" do
    it "assigns all settings to @settings" do
      @user = FactoryGirl.create(:admin_user)
      controller.session[:user_id] = @user.id
      get :index
      assigns(:settings).should eq(Setting.all)
    end
  end

  describe "#update" do
    before :each do
      @user = FactoryGirl.create(:admin_user)
      controller.session[:user_id] = @user.id
    end

    it "posts per page" do
      put :update, :posts => 30, "min-value" => -5, "max-value" => 5
      Setting.posts_per_page.should eq(30)
    end

    it "negative threshold" do
      put :update, :posts => 30, "min-value" => -5, "max-value" => 5
      Setting.negative_threshold.should eq(-5)
    end

    it "positive threshold" do
      put :update, :posts => 30, "min-value" => -5, "max-value" => 5
      Setting.positive_threshold.should eq(5)
    end

    it "redirects on success" do
      put :update, :posts => 30, "min-value" => -5, "max-value" => 5
      response.should be_redirect
    end

    it "does not redirect on failure" do
      put :update, :posts => -1, "min-value" => -5, "max-value" => 5
      response.should_not be_redirect
    end
  end

  describe "#find_setting" do
    it "assigns setting from params[:id] to @setting" do
      @setting = FactoryGirl.create(:setting)
      controller.params[:id] = @setting.id
      controller.send(:find_setting)
      assigns(:setting).should eq(@setting)
    end
  end
end
