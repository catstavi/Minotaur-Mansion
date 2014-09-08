require "./dungeon.rb"

########################

def make_this_dungeon(name)

  # a list of rooms and attributes

  room_array = [

     [:gateway, "Gateway", "A wall in front of you, and doors to the east and west",
       { north: :stonewall, east: :weaponsroom, south: :blockedgate, west: :tearoom },
        { key: "a big brass key", trash: "some dirty trash", flower: "a red red rose"},
        climb: "You'll have to get closer to the wall."],

      [:stonewall, "Stone Wall", "a tall stone wall covered in ivy",
          { south: :gateway}, {}, {climb: :walltop}],

      [:walltop, "Wall Top", "the top of the stone wall. Below you is a sloped ditch. There's no ivy on that side, so you'd have to jump. You could also climb back down to the Gate Room.",
      {}, {}, {jump: :slopedditch, climb_down: :gateway}],

      [:slopedditch, "Sloped Ditch", "You hurt your ankle jumping. You are in a sloped ditch with scrubby brush. There's a muddy creekbed.",
      {}, {}, {}],

      [:weaponsroom, "Weapons Room", "A room full of weapons. There's a door to the east.",
        { east: :broomcloset, west: :gateway }, {sword: "a long, chipped sword",
          axe: "a heavy battleaxe, stained with red", staff: "A big gnarly stick. Maybe it belonged to a wizard!"}, {}],

      [:broomcloset, "Broom Closet", "a small room with brooms",
        { west: :weaponsroom}, {broom: "a fine straw broom", mop:
          "a dirty old mop"}, {}],

      [:blockedgate, "Blocked Gate", "the gate is locked",
        { north: :gateway }, {}, {}],

      [:tearoom, "Tea Room", "A tea party room! yay!",
        { east: :gateway }, {tea: "Earl Grey. Nice.", teacup: "delicate and fine"},
        {:smash "You smash one of the teacups. Why would you do that? Luckily there are some more."}]

        ]

  my_dungeon = Dungeon.new(name)
  return create_rooms(my_dungeon, room_array)
end

def create_rooms(dungeon, room_array)
  room_array.each do |ref, name, desc, paths, items, actions|
    dungeon.add_room(ref, name, desc, paths, items, actions)
  end
  return dungeon
end
