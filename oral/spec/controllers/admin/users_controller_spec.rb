require 'spec_helper'

describe Admin::UsersController do
  describe "redirects" do
    it "redirects if not logged in on index" do
      get :index
      response.should be_redirect
    end

    it "redirects if not logged in on show" do
      get :show
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

    it "redirects if not admin in on index" do
      @user = FactoryGirl.create(:user)
      controller.session[:user_id] = @user.id
      get :index
      response.should be_redirect
    end

    it "redirects if not admin in on show" do
      @user = FactoryGirl.create(:user)
      controller.session[:user_id] = @user.id
      get :show
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
    it "assigns the users for the current page to @users" do
      @user = FactoryGirl.create(:admin_user)
      controller.session[:user_id] = @user.id
      get :index
      assigns(:users).should eq([@user])
    end
  end

  describe "#show" do
    it "finds user by id" do
      @user = FactoryGirl.create(:admin_user)
      controller.session[:user_id] = @user.id
      get :show, :id => @user.id, :page => 1
      assigns(:user).should eq(@user)
    end
  end

  describe "#new" do
    it "creates an empty @user" do
      @user = FactoryGirl.create(:admin_user)
      controller.session[:user_id] = @user.id
      get :new
      assigns(:user).class.should eq(User)
    end
  end

  describe "#edit" do
    it "assigns user to @user via :id" do
      @user = FactoryGirl.create(:admin_user)
      controller.session[:user_id] = @user.id
      get :edit, :id => @user.id, :page => 1
      assigns(:user).should eq(@user)
    end
  end

  describe "#create" do
    it "creates a new user, stored in @user" do
      @user = FactoryGirl.create(:admin_user)
      controller.session[:user_id] = @user.id
      @attrs = FactoryGirl.attributes_for(:user)
      post :create, :user => @attrs
      User.all.count.should eq(2)
    end

    it "redirects on success" do
      @user = FactoryGirl.create(:admin_user)
      controller.session[:user_id] = @user.id
      @attrs = FactoryGirl.attributes_for(:user)
      post :create, :user => @attrs
      response.should be_redirect
    end

    it "does not redirect on failure" do
      @user = FactoryGirl.create(:admin_user)
      controller.session[:user_id] = @user.id
      post :create, :user => {:email => "invalid"}
      response.should_not be_redirect
    end
  end

  describe "#update" do
    before :each do
      @user = FactoryGirl.create(:admin_user)
      controller.session[:user_id] = @user.id
    end

    it "updates user's attribuets" do
      old_pass = @user.encrypted_password
      put :update, :id => @user.id, :user => {:password => "123456"}
      User.first.encrypted_password.should_not eq(old_pass)
    end

    it "redirects on success" do
      put :update, :id => @user.id, :user => {:password => "123456"}
      response.should be_redirect
    end

    it "does not redirect on failure" do
      put :update, :id => @user.id, :user => {:password => "123"}
      response.should_not be_redirect
    end
  end

  describe "#destroy" do
    before :each do
      @user = FactoryGirl.create(:admin_user)
      controller.session[:user_id] = @user.id
    end

    it "destroys a user" do
      delete :destroy, :id => @user.id
      User.all.count.should eq(0)
    end

    it "redirects on success" do
      delete :destroy, :id => @user.id
      response.should be_redirect
    end
  end

  describe "#find_user" do
    it "finds a user and sets it in @user" do
      @user = FactoryGirl.create(:user)
      controller.params[:id] = @user.id
      controller.send(:find_user)
      assigns(:user).should eq(@user)
    end
  end
end
