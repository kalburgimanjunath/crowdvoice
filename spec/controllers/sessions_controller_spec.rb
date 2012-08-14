require 'spec_helper'

describe SessionsController do
  describe "#new" do
    it "exists" do
      lambda { get :new }.should_not raise_error
    end
  end

  describe "#create" do
    it "creates a session if the user exists" do
      @user = FactoryGirl.create(:user)
      post :create, :email => @user.email, :password => "example"
      controller.session[:user_id].should eq(@user.id)
    end

    it "redirects if session created" do
      @user = FactoryGirl.create(:user)
      post :create, :email => @user.email, :password => "example"
      response.should be_redirect
    end

    it "doesn't create a session if credentials don't match" do
      @user = FactoryGirl.create(:user)
      post :create, :email => @user.email, :password => "Not the password"
      controller.session[:user_id].should eq(nil)
    end
  end

  describe "#reset_password" do
    it "redirects to admin_root if there is a user" do
      @user = FactoryGirl.create(:user)
      session[:user_id] = @user.id
      get :reset_password
      response.should redirect_to(admin_root_path)
    end

    it "does not redirect if there is no user" do
      get :reset_password
      response.should_not be_redirect
    end
  end

  describe "#reset_password_notify" do
    it "changes the user's reset token" do
      @user = FactoryGirl.create(:user)
      lambda { get :reset_password_notify, :email => @user.email }.should change{ User.last.reset_password_token }
    end

    it "notifies the user via email" do
      @user = FactoryGirl.create(:user)
      get :reset_password_notify, :email => @user.email
      ActionMailer::Base.deliveries.last.to.should == [@user.email]
    end
  end

  describe "#destroy" do
    it "destroys the user session" do
      session[:user_id] = 1
      delete :destroy
      controller.session[:user_id].should eq(nil)
    end

    it "redirects to root" do
      delete :destroy
      response.should redirect_to(root_path)
    end
  end
end
