require 'spec_helper'

describe VotesController do
  describe "#create" do
    before :each do
      @voice = FactoryGirl.create(:non_featured_voice)
      @post = FactoryGirl.create(:approved_post, :voice => @voice)
      @user = FactoryGirl.create(:user)
      controller.session[:user_id] = @user.id
      post :create, :post_id => @post.id, :rating => 1, :format => :json
    end
    it "adds the vote to a post" do
      @post.votes.length.should eq(1)
    end

    it "adds the vote to the proper user" do
      @post.votes.first.user_id.should eq(@user.id)
    end
  end

  describe "#destroy" do
    it "deletes the vote" do
      @voice = FactoryGirl.create(:non_featured_voice)
      @post = FactoryGirl.create(:approved_post, :voice => @voice)
      @vote = FactoryGirl.create(:vote, :post => @post)
      delete :destroy, :id => @vote.id
      Vote.all.count.should eq(0)
    end
  end
end
