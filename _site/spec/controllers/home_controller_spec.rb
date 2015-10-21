require 'spec_helper'

describe HomeController do
  describe "#index" do
    before :each do
      @non_featured_voices = []
      3.times do |i|
        @non_featured_voices << FactoryGirl.create(:non_featured_voice)
      end

      @featured_voices = []
      3.times do |i|
        @featured_voices << FactoryGirl.create(:featured_voice)
      end
    end

    it "assigns the featured voices to @featured" do
      get :index
      assigns(:featured).should eq(@featured_voices)
    end

    it "assigns the featured to column" do
      get :index
      assigns(:columns).should eq([[@featured_voices[0]],[@featured_voices[1]],[@featured_voices[2]]])
    end
  end
end
