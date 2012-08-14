require 'spec_helper'

describe Vote do
  before(:all) do
    @vote = FactoryGirl.create(:vote)
  end
  it { should belong_to(:post) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:ip_address) }
  it "positive? method shoud return true if ratting is 1" do
    @vote.positive?.should be true
  end
  it "negative? method shoud return true if ratting is -1" do
    vote = FactoryGirl.create(:negative_vote)
    vote.negative?.should be true
  end
  it "update_vote_counters with positive raiting should increse positive_count" do
    current_positive_count = @vote.post.positive_votes_count
    FactoryGirl.create(:vote, post_id: @vote.post_id)
    @vote.reload
    @vote.post.positive_votes_count.should > current_positive_count
  end
  it "update_vote_counters with negative raiting should increse negavive_count" do
    current_negative_count = @vote.post.negative_votes_count
    FactoryGirl.create(:negative_vote, post_id: @vote.post_id)
    @vote.reload
    @vote.post.negative_votes_count.should > current_negative_count
  end
  it "should update post approved to true if overall_score is gratter the same as positive_threshold" do
    4.times { FactoryGirl.create(:vote, post_id: @vote.post_id) }
    @vote.reload
    @vote.post.approved.should be true
  end
  it "should update post approved to false if overall_score is less or the same as negative_threshold" do
    6.times { FactoryGirl.create(:negative_vote, post_id: @vote.post_id) }
    @vote.reload
    @vote.post.approved.should be false
  end
end

