require 'spec_helper'

describe Admin::HomepageController do
  describe "#show" do
    it "assigns featured voices to @voices" do
      @voice = FactoryGirl.create(:featured_voice)
      get :show
      assigns(:voices).should eq([@voice])
    end
  end

  describe "#update" do
    before :each do
      @voice = FactoryGirl.create(:featured_voice)
      @voice2 = FactoryGirl.create(:featured_voice)
    end
    it "assigns featured voices to @voices" do
      put :update, :voice => @voice2.id.to_s+","+@voice.id.to_s
      assigns(:voices).should eq([@voice, @voice2])
    end

    it "rearranges the voices" do
      put :update, :voice => @voice.id.to_s+","+@voice2.id.to_s
      Voice.first.home_position.should eq(1)
    end
  end
end
