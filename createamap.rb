require "./dungeon.rb"

########################

def make_this_dungeon(name)

  # a list of rooms and attributes

  room_array = [[:gateway, "Gateway", "A wall in front of you, and doors to the east and west",
    { north: :stonewall, east: :weaponsroom, south: :blockedgate, west: :tearoom },
     { key: "a big brass key", trash: "some dirty trash", flower: "a red red rose"},
     {climb: "You'll have to get closer to the wall."}],

     [:gateway, "Gateway", "A wall in front of you, and doors to the east and west",
       { north: :stonewall, east: :weaponsroom, south: :blockedgate, west: :tearoom },
        { key: "a big brass key", trash: "some dirty trash", flower: "a red red rose"}, {}],

      [:stonewall, "Stone Wall", "a tall stone wall covered in ivy",
          { south: :gateway}, {}, {climb: :walltop}],

      [:walltop, "Wall Top", "the top of the stone wall. Below you is a sloped ditch. There's no ivy on that side, so you'd have to jump. You could also climb back down to the Gate Room.",
      {}, {}, {jump: :slopedditch, climb_down: :gateway}],

      [:slopedditch, "Sloped Ditch", "you hurt your ankle jumping. you are in a sloped ditch with scrubby brush. There's a muddy creekbed.",
      {}, {}, {}],

      [:weaponsroom, "Weapons Room", "a room full of weapons",
        { east: :broomcloset, west: :gateway }, {sword: "a long, chipped sword",
          axe: "a heavy battleaxe, stained with red"}, {}],

      [:broomcloset, "Broom Closet", "a small room with brooms",
        { west: :weaponsroom}, {broom: "a fine straw broom", mop:
          "a dirty old mop"}, {}],

      [:blockedgate, "Blocked Gate", "the gate is locked",
        { north: :gateway }, {}, {}],

      [:tearoom, "Tea Room", "A tea party room! yay!",
        { east: :gateway }, {tea: "Earl Grey", teacup: "delicate and fine"}, {}]]

  my_dungeon = Dungeon.new(name)
  return create_rooms(my_dungeon, room_array)
  #
  # my_dungeon.add_room(:gateway, "Gateway", "A wall in front of you, and doors to the east and west",
  #   { north: :stonewall, east: :weaponsroom, south: :blockedgate, west: :tearoom },
  #    { key: "a big brass key", trash: "some dirty trash", flower: "a red red rose"} )
  #
  # my_dungeon.add_room(:stonewall, "Stone Wall", "a tall stone wall covered in ivy",
  #   { south: :gateway }, {})
  #
  # my_dungeon.add_room(:weaponsroom, "Weapons Room", "a room full of weapons",
  #   { east: :broomcloset, west: :gateway }, {sword: "a long, chipped sword",
  #     axe: "a heavy battleaxe, stained with red"})
  #
  # my_dungeon.add_room(:broomcloset, "Broom Closet", "a small room with brooms",
  #   { west: :weaponsroom}, {broom: "a fine straw broom", mop:
  #     "a dirty old mop"} )
  #
  # my_dungeon.add_room(:blockedgate, "Blocked Gate", "the gate is locked",
  #   { north: :gateway }, {})
  #
  # my_dungeon.add_room(:tearoom, "Tea Room", "A tea party room! yay!",
  #   { east: :gateway }, {tea: "Earl Grey", teacup: "delicate and fine"})
  #
  # return my_dungeon

end

def create_rooms(dungeon, room_array)
  room_array.each do |ref, name, desc, paths, items, actions|
    dungeon.add_room(ref, name, desc, paths, items, actions)
  end
  return dungeon
end
