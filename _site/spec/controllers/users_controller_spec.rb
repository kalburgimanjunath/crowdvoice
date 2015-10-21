require 'spec_helper'
require 'ruby-debug'

describe UsersController do
  describe "#create" do
    before :each do
      @attrs = FactoryGirl.attributes_for(:user)
    end
    it "creates a new user" do
      post :create, :user => @attrs
      User.all.count.should eq(1)
    end

    it "notifies via email" do
      post :create, :user => @attrs
      ActionMailer::Base.deliveries.last.to.should == [@attrs[:email]]
    end

    it "sends ok when valid" do
      post :create, :user => @attrs, :format => :json
      response.response_code.should eq(200)
    end

    it "sends unprocessable entity when invalid" do
      post :create, :user => {:email => "invalid"}, :format => :json
      response.response_code.should eq(422)
    end
  end

  describe "#reset_password" do
    it "assigns @user from user_id and reset_password_token" do
      @user = FactoryGirl.create(:user)
      @user.reset_token
      @user.save
      get :reset_password, :user_id => @user.id, :reset_password_token => @user.reset_password_token
      assigns(:user).should eq(@user)
    end
  end

  describe "#update_password" do
    before :each do
      @user = FactoryGirl.create(:user)
      @user.reset_token
      @user.save
    end
    it "assigns @user from user_id and reset_password_token" do
      get :update_password, :user_id => @user.id, :reset_password_token => @user.reset_password_token, :user => {:password => "123456"}
      assigns(:user).should eq(@user)
    end

    it "changes the user password" do
      get :update_password, :user_id => @user.id, :reset_password_token => @user.reset_password_token, :user => {:password => "123456"}
      @user.encrypted_password.should_not eq(User.last.encrypted_password)
    end

    it "sets the session" do
      get :update_password, :user_id => @user.id, :reset_password_token => @user.reset_password_token, :user => {:password => "123456"}
      controller.session[:user_id].should_not eq(nil)
    end

    it "redirects to admin_root_url on success" do
      get :update_password, :user_id => @user.id, :reset_password_token => @user.reset_password_token, :user => {:password => "123456"}
      response.should be_redirect
    end

    it "does not redirect when invalid" do
      get :update_password, :user_id => @user.id, :reset_password_token => "1", :user => {:password => "123456"}
      response.should_not be_redirect
    end
  end
end
