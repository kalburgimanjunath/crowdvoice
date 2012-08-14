require 'spec_helper'

describe User do
  before(:all) do
    @user = FactoryGirl.create(:user)
  end
  it { should have_many(:voices) }
  it { should have_many(:votes) }
  it { @user.should be_valid }
  it { should validate_uniqueness_of(:username) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:password) }
  it "password should be at least 6 characters" do
    @user.password.should_not < "6"
  end
  it "shouldn't no be admin by default" do
    @user.is_admin.should == false
  end
  it "shoud create a password salt before_save" do
    @user.password_salt.should_not == nil
  end
  it "shoud create a encrypted_password before_save" do
    @user.encrypted_password.should_not == nil
  end
end
