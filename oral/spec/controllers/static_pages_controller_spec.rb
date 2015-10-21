require 'spec_helper'

describe StaticPagesController do
  describe "#about" do
    it "exists" do
      lambda { get :about }.should_not raise_error
    end
  end

  describe "#sitemap" do
    it "assigns all the voices to @voices" do
      3.times do
        FactoryGirl.create(:non_featured_voice)
      end
      get :sitemap, :format => :xml
      assigns(:voices).should eq(Voice.all)
    end
  end
end
