require "./dungeon.rb"

########################

def make_this_dungeon(name)

  #Create the main dungeon object

  my_dungeon = Dungeon.new(name)

  #Add rooms to the dungeon

  my_dungeon.add_room(:gateway, "Gateway", "A wall in front of you, and doors to the east and west",
    { north: :stonewall, east: :weaponsroom, south: :blockedgate, west: :tearoom },
     { key: "a big brass key", trash: "some dirty trash", flower: "a red red rose"} )

  my_dungeon.add_room(:stonewall, "Stone Wall", "a tall stone wall covered in ivy",
    { south: :gateway }, {})

  my_dungeon.add_room(:weaponsroom, "Weapons Room", "a room full of weapons",
    { east: :broomcloset, west: :gateway }, {sword: "a long, chipped sword",
      axe: "a heavy battleaxe, stained with red"})

  my_dungeon.add_room(:broomcloset, "Broom Closet", "a small room with brooms",
    { west: :weaponsroom}, {broom: "a fine straw broom", mop:
      "a dirty old mop"} )

  my_dungeon.add_room(:blockedgate, "Blocked Gate", "the gate is locked",
    { north: :gateway }, {})

  my_dungeon.add_room(:tearoom, "Tea Room", "A tea party room! yay!",
    { east: :gateway }, {tea: "Earl Grey", teacup: "delicate and fine"})

  return my_dungeon

end
