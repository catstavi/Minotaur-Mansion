class Dungeon
  attr_accessor :player

  def initialize(player_name)
    @player = Player.new(player_name)
    @rooms = []
  end

  def add_room(reference, name, desc, paths, items, actions)
    @rooms << Room.new(reference, name, desc, paths, items, actions)
  end

  def start(location)
    @player.location = location
    show_current_description
  end

  def show_current_description
    puts find_room_in_dungeon(@player.location).full_description
  end

  def find_room_in_dungeon(reference)
    @rooms.detect { |room| room.reference == reference }
  end

  def find_room_in_direction(direction)
    find_room_in_dungeon(@player.location).paths[direction]
  end
  #
  # def room_result_of_action(action)
  #   @rooms.detect { |room| room.action == action }
  #

#If I'm going to use go for actions too I need to take out the text
  def go(direction)
    if find_room_in_direction(direction) == nil
      paths = find_room_in_dungeon(@player.location).paths.keys
      puts "You can't go that way. You can go: " + paths.join(', ')
    else
      puts "You go #{direction.to_s}."
      @player.location = find_room_in_direction(direction)
      show_current_description
    end
  end

  def do(action)
    location = find_room_in_dungeon(@player.location)
    action_value = location.actions[action]
    if action_value.is_a? Symbol
      @player.location = action_value
      show_current_description
    elsif action_value.is_a? String
      puts action_value
    else
      puts action_value
      puts "Error. Action result is not a symbol or a string"
    end
  end

  def return_actions
    find_room_in_dungeon(@player.location).actions.keys
  end


#### item methods ###
  def room_item_array
    find_room_in_dungeon(@player.location).items.keys
  end

  def show_room_items
    item_string = find_room_in_dungeon(@player.location).items.keys.join(", ")
    puts "Items in this room: #{item_string}"
  end

# takes item as symbol, all methods
  def show_item_desc(item)
    if @player.inventory.include?(item)
      @player.inventory[item]
    else
      find_room_in_dungeon(@player.location).items[item]
    end
  end

  def take_item(item)
    location = find_room_in_dungeon(@player.location)
    description = location.items[item]
    @player.add_to_inventory(item, description)
    location.items.delete(item)
  end

  def drop_item(item)
    location = find_room_in_dungeon(@player.location)
    description = location.items[item]
    @player.inventory.delete(item)
    location.add_item_to_room(item, description)
  end

###########################
  class Player
    attr_accessor :name, :location, :inventory

    def initialize(player_name)
      @name = player_name
      @inventory = {}
    end

    def add_to_inventory(item, description)
      @inventory[item] = description
    end

    def show_inventory
      puts "Inventory: " + @inventory.keys.join(', ')
    end

  end

  class Room
    attr_accessor :reference, :name, :desc, :paths, :items, :actions

    def initialize(reference, name, desc, paths, items, actions)
      @reference = reference
      @name = name
      @desc= desc
      @paths = paths
      @items = items
      @actions = actions
    end

    def full_description
      "\n#{@name}\n #{@desc}"
    end

    def add_item_to_room(item, description)
      @items[item] = description
    end
  end
end
