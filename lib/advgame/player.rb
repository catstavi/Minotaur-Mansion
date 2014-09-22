module AdvGame
  class Player
    attr_accessor :name, :location, :inventory, :status, :status_array

    def initialize(player_name, player_hash)
      @name = player_name
      @inventory = { }
      add_array_to_inventory(player_hash[:inventory])
      @status_array = player_hash[:status_set]
      @status = player_hash[:starter_status]
    end

    def add_to_inventory(item_ref, item_obj)
      @inventory[item_ref] = item_obj
    end

    def add_array_to_inventory(item_array)
      item_array.each do |item|
        add_to_inventory(item[:reference], AdvGame::Item.new(item))
      end
    end

    def show_inventory
      if inventory_array.length > 0
        puts "Inventory: " + inventory_array.join(', ')
      else
        puts "You have nothing. You should really be more careful with your things."
      end
    end

    def word_in_inventory?(word)
      puts "word: #{word}"
      inventory_array.include? word.to_sym
    end

    def inventory_array
      @inventory.keys
    end

    def show_status
      puts @status_array[@status]
    end

  end
end
