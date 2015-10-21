require 'spec_helper'

describe Announcement do
  before(:all) do
    @announcement = FactoryGirl.create(:announcement)
  end
  it { should belong_to(:voice) }
  it { should validate_presence_of(:voice_id) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:content) }
  it { @announcement.should be_valid }
end

