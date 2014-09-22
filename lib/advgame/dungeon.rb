module AdvGame
  class Dungeon
    attr_accessor :player, :actions
    attr_reader :rooms

    def initialize(player_name, player_hash)
      @player = AdvGame::Player.new(player_name, player_hash)
      @rooms = []
    end

    #creates both a new dungeon and all the rooms, from a room array
    def self.new_with_rooms(room_array, player_name, player_hash)
      my_dungeon = Dungeon.new(player_name, player_hash)
      room_array.each { |hash| my_dungeon.add_room(hash) }
      return my_dungeon
    end

    #adds a single room to the dungeon's room array from a hash filled with attributes
    def add_room(room_hash)
      @rooms << AdvGame::Room.new(room_hash)
    end

    #set the starting location for the player
    def start(location)
      @player.location = location
      show_current_description
    end

    def self.pass_dungeon(dungeon_instance)
      dungeon_instance.rooms.each do |room|
        room.pass_dungeon(dungeon_instance)
      end
    end

    def this_room
      find_room_in_dungeon(@player.location)
    end

    #find the room object of the player location, and runs the description method
    def show_current_description
      puts this_room.full_description
      puts this_room.show_items
    end

    # uses detect to find the room object with the matching reference given
    def find_room_in_dungeon(reference)
      @rooms.detect { |room| room.reference == reference }
    end

    # reach the room reference value of the direction key in the paths hash
    # (of current room location)
    # return the room reference
    def find_room_in_direction(direction)
      this_room.paths[direction]
    end

    #takes a direction, find the current room's hash and where that path leads
    def go(direction)
      destination = find_room_in_direction(direction)
      if destination == nil
        paths = possible_paths_array
        puts "You can't go that way. You can go: " + paths.join(', ')
      else
        puts "You go #{direction}."
        go_with_location(destination)
      end
    end

    def possible_paths_array
      this_room.paths.keys
    end

    #given a location (as a room object), sets the player there
    def go_with_location(location)
      @player.location = location
      find_room_in_dungeon(location)
      show_current_description
    end

    def check_actions(w1, w2)
      if w2==nil then w2 = " " end
      w2 = w2.to_sym
    #  action = dict(w1) #has sets of words all paired to the same key, the action reference
      case w1
      when /status/
        @player.show_status
      when /inventory/
        @player.show_inventory
      when "exit", "quit", "end"
        abort("You quitter!")
      when /look/
        puts show_current_description
      when "examine"
        examine_try(w2)
      when "take"
        take_try(w2)
      when "drop"
        drop_try(w2)
      when "go"
        go(w2)
      when nil
        puts "Your indecision is painful."
      else
        do_extra_action(w1.to_sym, w2)
      end
    end

    #actions attributes are arrays of action objects, in items/scenery

    def location_actions
      all_location_actions = []
      this_room.items.values.each do |item|
        all_location_actions += item.actions
      end
      return all_location_actions
    end

    def inventory_actions
      all_inventory_actions = []
      @player.inventory.values.each do |item|
        all_inventory_actions += item.actions
      end
      return all_inventory_actions
    end

    def available_actions
      inventory_actions + location_actions
    end

    def commands_list
      commands =['go', 'exit', 'status', 'inventory', 'look', 'examine', 'take', 'drop']
      commands += (available_actions.each { |action| action.reference } )
    end

    #should w2 trigger what item we are using? or scenery?
    #parser that tosses articles and prepositions?
    # and checks for actions that are two-word actions? "turn on" etc

    def do_extra_action(w1, w2)
      possible_actions = available_actions
      this_action = possible_actions.find { |action| action.reference == w1 }
      if this_action == nil
        puts "I don't understand. Try one of these: "
        puts commands_list.join(', ')
      elsif this_action.interpret_check(w2) == false
        puts this_action.fail_desc
      else
        action_results(this_action)
      end
    end

    def action_results(this_action)
      this_action.desc ? ( puts this_action.desc ) : nil
      this_action.status_change ? @player.status=(this_action.status_change) : nil
      this_action.path ? go_with_location(this_action.path) : nil
    end

  #### item methods ###

  # takes item as symbol, all methods

    def take_try(item_ref)
      if !(this_room.word_in_room?(item_ref))
        puts """
  You reach out for it, but your hands pass straight through.
  You must have been hallucinating.
        """
      elsif this_room.items[item_ref].takeable == false
        puts "You can't take that."
      else
        take_item(item_ref)
      end
    end

    def take_item(item_ref)
      puts "You take the #{item_ref}. Cool!"
      item_obj = this_room.items[item_ref]
      @player.add_to_inventory(item_ref, item_obj)
      this_room.items.delete(item_ref)
    end

    def drop_try(item_ref)
      if @player.word_in_inventory?(item_ref)
        drop_item(item_ref)
      else
        puts "You can't find that anywhere! How will you drop it!? You panic."
      end
    end

    def drop_item(item)
      puts "Oblivious to litter laws, you drop the #{item}."
      item_obj = @player.inventory[item]
      this_room.add_item_to_room(item, item_obj)
      @player.inventory.delete(item)
    end

    def examine_try(item_ref)
      if @player.word_in_inventory?(item_ref)
        examine_item(@player.inventory[item_ref])
      elsif this_room.word_in_room?(item_ref)
        examine_item(this_room.items[item_ref])
      else
        puts "You carefully examine the concept of a #{item_ref} in your mind."
      end
    end

    def examine_item(item_obj)
      puts item_obj.desc
    end
  end
end
