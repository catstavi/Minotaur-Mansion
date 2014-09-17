class Dungeon
  attr_accessor :player, :actions
  attr_reader :rooms

  def initialize(player_name)
    @player = Player.new(player_name)
    @rooms = []
  end

  #creates both a new dungeon and all the rooms, from a room array
  def self.new_with_rooms(room_array, player_name)
    my_dungeon = Dungeon.new(player_name)
    room_array.each { |hash| my_dungeon.add_room(hash) }
    return my_dungeon
  end

  #adds a single room to the dungeon's room array from a hash filled with attributes
  def add_room(room_hash)
    @rooms << Room.new(room_hash)
  end

  #set the starting location for the player
  def start(location)
    @player.location = location
    show_current_description
  end

  #find the room object of the player location, and runs the description method
  def show_current_description
    puts find_room_in_dungeon(@player.location).full_description
  end

  # uses detect to find the room object with the matching reference given
  def find_room_in_dungeon(reference)
    @rooms.detect { |room| room.reference == reference }
  end

  # reach the room reference value of the direction key in the paths hash
  # (of current room location)
  # return the room reference
  def find_room_in_direction(direction)
    find_room_in_dungeon(@player.location).paths[direction]
  end

  #takes a direction, find the current room's hash and where that path leads
  def go(direction)
    if find_room_in_direction(direction) == nil
      paths = possible_paths_array
      puts "You can't go that way. You can go: " + paths.join(', ')
    else
      puts "You go #{direction}."
      destination = find_room_in_direction(direction)
      go_with_location(destination)
    end
  end

  def possible_paths_array
    find_room_in_dungeon(@player.location).paths.keys
  end

  #given a location (as a room object), sets the player there
  def go_with_location(location)
    @player.location = location
    puts "Player location is #{@player.location}"
    show_current_description
  end

  def check_actions(w1, w2)
    if w2 then w2 = w2.to_sym end
  #  aciton = dict(w1) #has sets of words all paired to the same key, the action reference
    case w1
    when /status/
      puts "You are feeling #{@player.status}."
    when /inventory/
      if @player.inventory_array.length > 0
        puts "Inventory: #{@player.inventory_array.join(', ')}."
      else
        puts "You have nothing. You should really be more careful with your things."
      end
    when "exit", "quit", "end"
      abort("You quitter!")
    when /look/
      puts show_current_description, show_room_items
    when "examine"
      examine_try(w2)
    when "take"
      take_try(w2)
    when "drop"
      drop_try(w2)
    when "go"
      go(w2)
    when ""
      puts "Your indecision is painful."
    else
      do_extra_action(w1.to_sym, w2)
    end
  end

  def available_actions
    location = find_room_in_dungeon(@player.location)
    location.items.actions.merge(@players.inventory.actions)
  end

  def do_extra_action(w1, w2)
    possible_actions = available_actions
    if possible_actions[:special_check] == false
      puts action[:fail_desc]
    elsif possible_actions[action] == nil
      puts "You try but you can't."
    else
      if action[:desc] then puts action[:desc] end
      if action[:status] then change_status(w2) end
      if action[:path] then go(w2) end
    end
  end

#### item methods ###
  def room_item_array
    find_room_in_dungeon(@player.location).items.keys
  end

  def show_room_items
    if room_item_array.length == 0
      puts "There are no items here."
    else
      item_string = room_item_array.join(", ")
      puts "Items in this room: #{item_string}"
    end
  end

# takes item as symbol, all methods

  def word_is_in_room?(word)
    if room_item_array.include? word.to_sym
      return true
    else
      return false
    end
  end

  def show_item_desc(item)
    if @player.inventory.include?(item)
      @player.inventory[item].desc
    else
      find_room_in_dungeon(@player.location).items[item].desc
    end
  end

  def take_try(item_ref)
    if word_is_in_room?(item_ref)
      take_item(item_ref)
    else
      puts """
You reach out for it, but your hands pass straight through.
You must have been hallucinating.
      """
    end
  end

  def take_item(item)
    location = find_room_in_dungeon(@player.location)
    puts "You take the #{item_ref}. Cool!"
    item_obj = location.items[item_ref]
    @player.add_to_inventory(item_ref, item_obj)
    location.items.delete(item_ref)
  end

  def drop_try(item_ref)
    if word_is_in_inventory?(item_ref)
      drop_item(item_ref)
    else
      puts "You can't find that anywhere! How will you drop it!? You panic."
    end
  end

  def drop_item(item)
    location = find_room_in_dungeon(@player.location)
    item_obj = location.items[item_ref]
    @player.inventory.delete(item_ref)
    location.add_item_to_room(item_ref, item_obj)
  end

  def examine_try(item_ref)
    if word_is_in_inventory?(item_ref)
      examine_item(@player.inventory[item_ref])
    elsif word_is_in_room?(item_ref)
      examine_item(@room.items[item_ref])
    else
      puts "That's not an item here."
    end
  end

  def examine_item(item_obj)
    puts item_obj.desc
  end

end

###########################
class Player
  attr_accessor :name, :location, :inventory, :status

  def initialize(player_name)
    @name = player_name
    @inventory = { }
    @status = "strong and healthy"
  end

  def add_to_inventory(item_ref, item_obj)
    @inventory[item_ref] = item_obj
  end

  def show_inventory
    puts "Inventory: " + inventory_array.join(', ')
  end

  def inventory_array
    @inventory.keys
  end

end

# :items includes both items and scenery (everything intereactive)
# takeable and nontakable

class Room
  attr_accessor :reference, :name, :desc, :paths, :items, :actions

  def initialize(room_hash)
    @reference = room_hash[:reference]
    @name = room_hash[:name]
    @desc= room_hash[:desc]
    @paths = room_hash[:paths]
    @items = { }
    populate_items(room_hash[:items])
    # populate_scenerey(room_hash[:scenerey])
    @actions = room_hash[:actions]
  end

  def full_description
    "\n#{@name}\n #{@desc}"
  end

## room_hash[:items] is an array of hashes full of item features.
## each room will have @items which is a hash, the key set to the item reference
## and the value the actual item object

  def populate_items(item_array)
    item_array.each do |item|
      @items[item[:reference]] = Item.new(item)
    end
  end

  # def populate_scenery(scenery_array)
  #   scenery_array.each do |thing|
  #     @items[thing[:reference]] = Scenery.new(thing)
  #   end
  # end

  def add_item_to_room(item_ref, item_obj)
    @items[item_ref] = item_obj
  end

end

class Interactive
  attr_accessor :reference, :name, :desc, :actions

  def initialize(info_hash)
    @reference = info_hash[:reference]
    @name = info_hash[:name]
    @desc = info_hash[:desc]
    @actions = info_hash[:actions]
  end

end

class Item < Interactive

end

class Scenery < Interactive

  def initialize
    super
    @takable = false
  end

end

class Action
  attr_accessor :reference, :desc, :path, :status_change, :special_check, :fail_desc

  def initialize(action_hash)
    @reference = action_hash[:reference]
    @desc = action_hash[:desc]
    @result = action_hash[:result]
    @status_change = action_hash[:status_change]
    @special_check = action_hash[:special_check]
    @fail_desc = action_hash[:fail_desc]
    if @special_check == nil then @special_check = true end
  end
end
