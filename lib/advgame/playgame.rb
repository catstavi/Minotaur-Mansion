### to-do
# create parser that removes 'the' and 'a'/'an', instead of checking each word
# for actions, let two word actions be understandable without '_' (also items)
# non takeable scenery
# how to get special check to work-- give Item class access to player?

class GameEngine

  def play
    puts "Running an Adventure Game!"
    name = get_name
    @map = choose_map(name)
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
    when "1" then []
    when "2" then return CaveMap.new
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
