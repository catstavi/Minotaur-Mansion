module AdvGame
  class Action
    attr_accessor :reference, :desc, :path, :status_change, :special_check, :fail_desc

    def initialize(action_hash)
      @reference = action_hash[:reference]
      @desc = action_hash[:desc]
      @path = action_hash[:path]
      @status_change = action_hash[:status_change]
      @special_check = action_hash[:special_check]
      @fail_desc = action_hash[:fail_desc]
      #if @special_check == nil then @special_check = true end
    end

    def set_dungeon(dungeon_instance)
      @dungeon = dungeon_instance
    end

    def interpret_check(w2)
      case @special_check
      when nil
        true
      when :holding_this
        @dungeon.player.word_in_inventory?(w2)
      else
        puts "You can't do that because the program doesn't know what #{@special_check} means."
        return false
      end
    end
  end
end
