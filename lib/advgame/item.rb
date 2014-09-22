# I think that inheritance doesn't make sense here, unless I am adding
# methods that inherit to some things and not others.
module AdvGame
  class Item
    attr_accessor :reference, :name, :desc, :actions, :takeable, :dungeon

    def initialize(info_hash)
      @reference = info_hash[:reference]
      @name = info_hash[:name]
      @desc = info_hash[:desc]
      @actions = [ ]
      @takeable = info_hash[:takeable]
      action_array = info_hash[:actions]
      if action_array then populate_actions(action_array) end
    end

    def populate_actions(action_array)
      action_array.each do |action|
        @actions << AdvGame::Action.new(action)
      end
    end

    def pass_dungeon(dungeon_instance)
      @dungeon = dungeon_instance
      @actions.each do |action|
        action.set_dungeon(dungeon_instance)
      end
    end
    
  end
end
