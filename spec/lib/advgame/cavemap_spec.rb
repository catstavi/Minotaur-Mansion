require 'spec_helper'

describe AdvGame::CaveMap do
  let(:cavemap) {AdvGame::CaveMap.new}

  describe "#status_set" do
    it "is a hash" do
      expect(cavemap.status_set.class).to eq Hash
    end
  end

  describe "#player_hash" do
    it "is a hash" do
      expect(cavemap.player_hash.class).to eq Hash
    end

    it "has a status_set" do
      expect(cavemap.player_hash[:status_set].class).to eq Hash
    end

    it "has a starter_status" do
      expect(cavemap.player_hash[:starter_status].class).to eq Symbol
    end

    it "has a starter_status that also exists in status_set" do
      all_statuses = cavemap.status_set.keys
      expect(all_statuses.include? cavemap.player_hash[:starter_status]).to eq true
    end
  end

  describe "#actions" do
    it "is a hash" do
      expect(cavemap.actions.class).to eq Hash
    end

    it "values of the hash are arrays" do
      expect(cavemap.actions.values[0].class).to eq Array
    end

    it "contents of the arrays (in the values of the hash) are hashes" do
      expect(cavemap.actions.values[0][0].class).to eq Hash
    end

    it "keys of the action hash match item references in the item hash" do
      full_item_array = []
      cavemap.items.values.each { |item_array| full_item_array += item_array }
      items = full_item_array.collect { |item_hash| item_hash[:reference] }
      expect(cavemap.actions.keys - items).to eq []
    end
  end
end



  #
  # describe "#inventory" do
  #   it "is a hash" do
  #     expect(cavemap.player_hash.class).to eq Hash
  #   end
