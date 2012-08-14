require 'spec_helper'

describe Subscription do
  before(:all) do
    @subscription = FactoryGirl.create(:subscription)
  end
  it { should belong_to(:voice) }
  it { should validate_presence_of(:email) }
  it "should be unique by email" do
    FactoryGirl.create(:subscription, email: "user1@example.com", voice_id: 1 )
    user = FactoryGirl.build(:subscription, email: "user1@example.com", voice_id: 1 )
    user.should_not be_valid
    user.errors.include?(:email).should be true
  end
  it "should have presence of email hash" do
    @subscription.email_hash.should_not be nil
  end
  it "email_hash should be unique" do
    user = FactoryGirl.create(:subscription)
    @subscription.email_hash.should_not be user.email_hash  
  end
  it "to_param method should return the email hash" do
    @subscription.to_param.should be @subscription.email_hash 
  end
end


