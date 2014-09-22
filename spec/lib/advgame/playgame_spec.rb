require 'spec_helper'

describe AdvGame::GameEngine do
  let(:engine) {AdvGame::GameEngine.new}

  describe "#get_name" do
    before do
      $stdin = StringIO.new("NAME HERE\n")
    end

    after do
      $stdin = STDIN
    end

    it "takes & returns user input" do
      expect(engine.get_name).to eq "NAME HERE"
    end
  end

  describe "#choose_map" do
    before do
      $stdin = StringIO.new("2\n")
    end

    after do
      $stdin = STDIN
    end

    it "returns a new map object, or object that inherits from Map" do
      expect(engine.choose_map.class.ancestors).to include(AdvGame::Map)
    end
  end

  describe "#play" do
    it "creates a new dungeon object" do
      #I don't know how to test this when the obj isn't returned
    end
  end
end
