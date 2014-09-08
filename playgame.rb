### to-do
# stop game from crashing when unset direction is picked
# create parser that removes 'the' and 'a'/'an'
# let user take actions unique to each room (climb the wall etc), and loop to
# next room/back to current w/o a direction

require "./createamap.rb"

class GameEngine

  def play
    puts "Running an Adventure Game!"
    name = get_name
    puts "Okay, #{name}, starting your game."
    @my_dungeon = make_this_dungeon(name)
    @my_dungeon.start(:gateway)
    while true
      print "> "
      action = gets.chomp
      check_action(action)
    end
  end

  def get_name
    puts "What's your character name?"
    print "> "
    gets.chomp
  end

  def check_action(input)
    words = input.split(' ')
    case words[0]
    when "go"
      go(words)
    when "exit"
      abort("You quitter!")
    when "status"
      puts "Gives player status"
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
      puts "type 'go', or a command"
    end
  end

  def word_is_in_room(item)
    items = @my_dungeon.room_item_array
    if items.include? item.to_sym
      return true
    else
      return false
    end
  end

  def word_is_in_inventory(item)
    items = @my_dungeon.player.inventory.keys
    if items.include? item.to_sym
      return true
    else
      return false
    end
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
    return "It seems you already dropped that without noticing, as you can't find it anywhere."
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
