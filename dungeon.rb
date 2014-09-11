class Dungeon
  attr_accessor :player
  attr_reader :rooms

  def initialize(player_name)
    @player = Player.new(player_name)
    @rooms = []
  end

  def self.new_with_rooms(room_array, player_name)
    my_dungeon = Dungeon.new(player_name)
    room_array.each { |hash| my_dungeon.add_room(hash) }
    return my_dungeon
  end

  def add_room(room_hash)
    @rooms << Room.new(room_hash)
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
    item_string = room_item_array.join(", ")
    puts "Items in this room: #{item_string}"
  end

# takes item as symbol, all methods
  def show_item_desc(item)
    if @player.inventory.include?(item)
      @player.inventory[item].desc
    else
      find_room_in_dungeon(@player.location).items[item].desc
    end
  end

  def take_item(item_ref)
    location = find_room_in_dungeon(@player.location)
    item_obj = location.items[item_ref]
    @player.add_to_inventory(item_ref, item_obj)
    location.items.delete(item_ref)
  end

  def drop_item(item_ref)
    location = find_room_in_dungeon(@player.location)
    item_obj = location.items[item_ref]
    @player.inventory.delete(item_ref)
    location.add_item_to_room(item_ref, item_obj)
  end
end

###########################
class Player
  attr_accessor :name, :location, :inventory, :status

  def initialize(player_name)
    @name = player_name
    @inventory = { }
    @status = "strong and healthy."
  end

  def add_to_inventory(item_ref, item_obj)
    @inventory[item_ref] = item_obj
  end

  def show_inventory
    puts "Inventory: " + @inventory.keys.join(', ')
  end

end

class Room
  attr_accessor :reference, :name, :desc, :paths, :items, :actions

  def initialize(room_hash)
    @reference = room_hash[:reference]
    @name = room_hash[:name]
    @desc= room_hash[:desc]
    @paths = room_hash[:paths]
    populate_items(room_hash[:items])
    @actions = room_hash[:actions]
  end

  def full_description
    "\n#{@name}\n #{@desc}"
  end

## room_hash[:items] is an array of hashes full of item features.
## each room will have @items which is a hash, the key set to the item reference
## and the value the actual item object

  def populate_items(item_array)
    @items = Hash.new(0)
    item_array.each do |item|
      @items[item[:reference]] = Item.new(item)
    end
  end

  def add_item_to_room(item_ref, item_obj)
    @items[item_ref] = item_obj
  end

end

class Item
  attr_accessor :reference, :name, :desc, :actions

  def initialize(info_hash)
    @reference = info_hash[:reference]
    @name = info_hash[:name]
    @desc = info_hash[:desc]
    @actions = info_hash[:actions]
  end

end
