### to-do
# create parser that removes 'the' and 'a'/'an', instead of checking each word
# for actions, let two word actions be understandable without '_' (also items)
# items should also have actions? (ex "put on hat") maybe we need an item class?
# room-actions affecting items or status as well as location


require "./createamap.rb"

class GameEngine

  def play
    puts "Running an Adventure Game!"
    name = get_name
    map_key = choose_map(name)
    @map = Map.new(Map.maps[map_key])
    @my_dungeon = Dungeon.new_with_rooms(@map.room_array, name)
    @my_dungeon.start(@map.start_room)
    while true
      print "> "
      action = gets.chomp
      check_action(action)
    end
  end

  def choose_map(name)
    puts "Okay, #{name}, what adventure would you like to have?"
    puts "1. Minotaur Mansion"
    puts "2. Caves"
    print "> "
    map_choice = gets.chomp
    case map_choice
    when "1" then return :minotaur_mansion
    when "2" then return :caves
    else puts "You need to choose 1 or 2."
    end
  end

  def get_name
    puts "What's your character name?"
    print "> "
    gets.chomp
  end

  def check_action(input)
    words = input.downcase.split(' ')
    @my_dungeon.check_actions(words[0], words[1])
  end

end

thisgame = GameEngine.new
thisgame.play
