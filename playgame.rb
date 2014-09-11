### to-do
# create parser that removes 'the' and 'a'/'an', instead of checking each word
# for actions, let two word actions be understandable without '_' (also items)
# items should also have actions? (ex "put on hat") maybe we need an item class?
# room-actions affecting items or status as well as location
#
# start room should not have to be changed in game engine for each map

require "./createamap.rb"

class GameEngine

  def play
    puts "Running an Adventure Game!"
    name = get_name
    puts "Okay, #{name}, starting your game."
    @my_dungeon = Dungeon.new_with_rooms(return_room_array, name)
    @my_dungeon.start(:gateway)
    while true
      print "> "
      action = gets.chomp
      check_action(action)
    end
  end

  # def create_rooms(dungeon, room_array)
  #   room_array.each { |hash| dungeon.add_room(hash) }
  #   return dungeon
  # end

  def get_name
    puts "What's your character name?"
    print "> "
    gets.chomp
  end

  def check_action(input)
    words = input.split(' ')
    if word_is_action(words[0])
      action(words[0])
    else
      case words[0]
      when "go"
        go(words)
      when "exit", "quit"
        abort("You quitter!")
      when "status"
        puts check_status
      when "look"
        @my_dungeon.show_current_description
        @my_dungeon.show_room_items
      when "examine"
        puts examine(words[1..words.length])
      when "take"
        puts take(words[1..words.length])
      when "drop"
        puts drop(words[1..words.length])
      when "inventory"
        @my_dungeon.player.show_inventory
      else
        commands =['go (direction)', 'exit', 'status', 'inventory', 'look', 'examine (item)', 'take (item)', 'drop (item)']
        commands = commands + @my_dungeon.return_actions
        puts "I don't understand. Try one of these: "
        puts commands.join(', ')
      end
    end
  end

  def word_is_in_room(word)
    items = @my_dungeon.room_item_array
    if items.include? word.to_sym
      return true
    else
      return false
    end
  end

  def word_is_in_inventory(word)
    items = @my_dungeon.player.inventory.keys
    if items.include? word.to_sym
      return true
    else
      return false
    end
  end

  def word_is_action(word)
    actions = @my_dungeon.return_actions
    if actions.include? word.to_sym
      return true
    else
      return false
    end
  end

  def check_status
    "You are feeling #{@my_dungeon.player.status}"
  end

  def action(word)
    @my_dungeon.do(word.to_sym)
  end

  def examine(input)
    input.each do |word|
      if word_is_in_room(word) || word_is_in_inventory(word)
        return @my_dungeon.show_item_desc(word.to_sym)
      end
    end
    return "That's not an item here."
  end

  def drop(input)
    input.each do|word|
      if word_is_in_inventory(word)
        @my_dungeon.drop_item(word.to_sym)
        return "Oblivious to litter laws, you drop the #{word}."
      end
    end
    return "You can't find that anywhere! How will you drop it!? You panic."
  end

  def take(input)
    input.each do |word|
      if word_is_in_room(word)
        @my_dungeon.take_item(word.to_sym)
        return "You take the #{word}! Cool!"
      end
    end
    return "You reach out for it, but your hands pass straight through. You must have been hallucinating."
  end

  def go(parsed_user_input)
    case parsed_user_input[1]
    when "east"
      @my_dungeon.go(:east)
    when "west"
      @my_dungeon.go(:west)
    when "north"
      @my_dungeon.go(:north)
    when "south"
      @my_dungeon.go(:south)
    else
      puts "That's not a direction I recognize. Try the standard cardinal directions."
    end
  end
end

thisgame = GameEngine.new
thisgame.play
