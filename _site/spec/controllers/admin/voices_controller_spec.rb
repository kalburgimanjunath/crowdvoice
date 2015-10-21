require 'spec_helper'

describe Admin::VoicesController do
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
  end

  describe "#index" do
    it "sets voices for the current page in @voices" do
      @user = FactoryGirl.create(:admin_user)
      controller.session[:user_id] = @user.id
      @voice = FactoryGirl.create(:non_featured_voice)
      get :index
      assigns(:voices).should eq([@voice])
    end
  end

  describe "#new" do
    it "creates an empty voice in @voice" do
      @user = FactoryGirl.create(:admin_user)
      controller.session[:user_id] = @user.id
      get :new
      assigns(:voice).class.should eq(Voice)
    end
  end

  describe "#create" do
    before :each do
      @user = FactoryGirl.create(:admin_user)
      controller.session[:user_id] = @user.id
    end

    it "creates a new voice sets it in @voice" do
      @attrs = FactoryGirl.attributes_for(:non_featured_voice)
      post :create, :voice => @attrs
      Voice.all.count.should eq(1)
    end

    it "notifies admins" do
      @attrs = FactoryGirl.attributes_for(:non_featured_voice)
      post :create, :voice => @attrs
      ActionMailer::Base.deliveries.last.to.should == [@user.email]
    end

    it "redirects on success" do
      @attrs = FactoryGirl.attributes_for(:non_featured_voice)
      post :create, :voice => @attrs
      response.should be_redirect
    end

    it "does not redirect on failure" do
      post :create, :voice => {:title => ""}
      response.should_not be_redirect
    end
  end

  describe "#edit" do
    it "assigns a voice in @voice via slug" do
      @user = FactoryGirl.create(:admin_user)
      controller.session[:user_id] = @user.id
      @voice = FactoryGirl.create(:non_featured_voice)
      get :edit, :id => @voice.slug
      assigns(:voice).should eq(@voice)
    end
  end

  describe "#update" do
    before :each do
      @user = FactoryGirl.create(:admin_user)
      controller.session[:user_id] = @user.id
    end

    it "updates the attributes of @voice" do
      @voice = FactoryGirl.create(:non_featured_voice)
      new_title = "New Title"
      put :update, :id => @voice.slug, :voice => {:title => new_title}
      Voice.first.title.should eq(new_title)
    end

    it "redirects on success" do
      @voice = FactoryGirl.create(:non_featured_voice)
      new_title = "New Title"
      put :update, :id => @voice.slug, :voice => {:title => new_title}
      response.should be_redirect
    end

    it "does not redirect on failure" do
      @voice = FactoryGirl.create(:non_featured_voice)
      put :update, :id => @voice.slug, :voice => {:title => ""}
      response.should_not be_redirect
    end
  end

  describe "#destroy" do
    before :each do
      @user = FactoryGirl.create(:admin_user)
      controller.session[:user_id] = @user.id
      @voice = FactoryGirl.create(:non_featured_voice)
    end

    it "destroys a @voice" do
      delete :destroy, :id => @voice.slug
      Voice.all.count.should eq(0)
    end

    it "redirects" do
      delete :destroy, :id => @voice.slug
      response.should be_redirect
    end
  end

  describe "#find_voice" do
    it "finds a voice by slug" do
      @user = FactoryGirl.create(:admin_user)
      controller.session[:user_id] = @user.id
      @voice = FactoryGirl.create(:non_featured_voice)
      controller.params[:id] = @voice.slug
      controller.send(:find_voice)
      assigns(:voice).should eq(@voice)
    end
  end

  describe "#build_scoped_voice" do
    it "assigns the voice to a user if not admin" do
      @user = FactoryGirl.create(:user)
      controller.session[:user_id] = @user.id
      @attrs = FactoryGirl.attributes_for(:non_featured_voice)
      @voice = controller.send(:build_scoped_voice, @attrs)
      @voice.user.should eq(@user)
    end

    it "does not assign the voice to any user if current is admin" do
      @user = FactoryGirl.create(:admin_user)
      controller.session[:user_id] = @user.id
      @attrs = FactoryGirl.attributes_for(:non_featured_voice)
      @voice = controller.send(:build_scoped_voice, @attrs)
      @voice.user.should_not eq(@user)
    end
  end

  describe "#scoped_voice" do
    it "returns all the voices if the user is admin" do
      @user = FactoryGirl.create(:admin_user)
      controller.session[:user_id] = @user.id
      @voice = FactoryGirl.create(:non_featured_voice)
      @voice2 = FactoryGirl.create(:non_featured_voice, :user => @user)
      controller.send(:scoped_voice).to_a.should eq(Voice.order('created_at  desc').to_a)
    end

    it "returns all of the user's voices if he is not admin" do
      @user = FactoryGirl.create(:user)
      controller.session[:user_id] = @user.id
      @voice = FactoryGirl.create(:non_featured_voice)
      @voice2 = FactoryGirl.create(:non_featured_voice, :user => @user)
      controller.send(:scoped_voice).should eq([@voice2])
    end
  end
end
