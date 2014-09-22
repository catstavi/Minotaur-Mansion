
# :items includes both items and scenery (everything intereactive)
# takeable and nontakable
module AdvGame
  class Room
    attr_accessor :reference, :name, :desc, :paths, :items

    def initialize(room_hash)
      @reference = room_hash[:reference]
      @name = room_hash[:name]
      @desc= room_hash[:desc]
      @paths = room_hash[:paths]
      @items = { }
      item_array = room_hash[:items]
      if item_array then populate_items(item_array) end
    end

    def pass_dungeon(dungeon_instance)
      @items.values.each do |item|
        item.pass_dungeon(dungeon_instance)
      end
    end

    def full_description
      "\n#{@name}\n #{@desc}"
    end

  ## room_hash[:items] is an array of hashes full of item features.
  ## each room will have @items which is a hash, the key set to the item reference
  ## and the value the actual item object

  ##whats the point of not just having the item object itself in the array? this might make more sense

    def populate_items(item_array)
      item_array.each do |item|
        @items[item[:reference]] = AdvGame::Item.new(item)
      end
    end

    def add_item_to_room(item_ref, item_obj)
      @items[item_ref] = item_obj
    end

    def word_in_room?(word)
      item_array.include? word
    end

    def item_array
      @items.keys
    end

    def show_items
      if item_array.length == 0
        puts "There's nothing here."
      else
        item_string = item_array.join(", ")
        puts "Stuff in this room: #{item_string}"
      end
    end

  end
end
