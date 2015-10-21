require 'spec_helper'

describe SubscriptionsController do
  describe "#create" do
    before :each do
      @voice = FactoryGirl.create(:non_featured_voice)
      @attrs = FactoryGirl.attributes_for(:subscription)
    end
    it "creates a new subscription in @subscription" do
      post :create, :voice_id => @voice.slug, :subscription => @attrs
      Subscription.all.count.should eq(1)
    end

    it "enqueues a confirmation job" do
      post :create, :voice_id => @voice.slug, :subscription => @attrs
      Delayed::Job.count.should eq(1)
    end

    it "redirects to the voice on success" do
      post :create, :voice_id => @voice.slug, :subscription => @attrs
      response.should redirect_to(voice_path(@voice))
    end

    it "redirects to the voice on failure" do
      post :create, :voice_id => @voice.slug, :subscription => {:email => "invalid"}
      response.should redirect_to(voice_path(@voice))
    end
  end

  describe "#destroy" do
    before :each do
      @voice = FactoryGirl.create(:non_featured_voice)
      @subscription = FactoryGirl.create(:subscription)
    end
    it "destroys the subscription" do
      delete :destroy, :voice_id => @voice.slug, :id => @subscription.email_hash
      Subscription.all.count.should eq(0)
    end

    it "redirects to the voice" do
      delete :destroy, :voice_id => @voice.slug, :id => @subscription.email_hash
      response.should redirect_to(voice_path(@voice))
    end
  end

  describe "#find_voice" do
    it "finds a voice and assigns it to @voice" do
      @voice = FactoryGirl.create(:non_featured_voice)
      controller.params = {:voice_id => @voice.slug}
      controller.send(:find_voice)
      assigns(:voice).should eq(@voice)
    end
  end
end
