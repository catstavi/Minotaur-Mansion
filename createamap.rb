require "./dungeon.rb"

# c&p when creating new room
#  { reference:
#   name:
#   desc:
#   paths:
#   items:
#   actions:
# }
#
# c&p when adding a new item
#
# { reference:
#   name:
#   desc:
#   actions:
# }



########################

class Map

  attr_accessor :room_array, :start_room

  #starting room is always the first room in your room array

  def initialize(room_array)
    @room_array = room_array
    @start_room = room_array[0][:reference]
  end

  def self.maps
    # each array represents a set of rooms (a different map/game)
    # the starting room will be the first room in the array

  minotaur_mansion = [
        { reference: :gateway,
          name: "Gateway",
          desc: "A wall in front of you, and doors to the east and west",
          paths: { north: :stonewall, east: :weaponsroom, south: :blockedgate, west: :tearoom },
          items: { key: "a big brass key",
                   trash: "some dirty trash",
                   flower: "a red red rose"},
          actions: { climb: "You'll have to get closer to the wall." }
        },

        { reference: :stonewall,
          name: "Stone Wall",
          desc: "a tall stone wall covered in ivy",
          paths: { south: :gateway },
          items: { }, #no items
          actions: { climb: :walltop }
        },

        { reference: :walltop,
          name: "Wall Top",
          desc: "the top of the stone wall. Below you is a sloped ditch. There's no ivy on that side, so you'd have to jump. You could also climb back down to the Gate Room.",
          paths: { }, #no direction paths
          items: { }, #no items initialized
          actions: {jump: :slopedditch, climb_down: :gateway}
        },

        { reference: :slopedditch,
          name: "Sloped Ditch",
          desc: "You hurt your ankle jumping. You are in a sloped ditch with scrubby brush. There's a muddy creekbed.",
          paths: { },
          items: { },
          actions: { }
        },

        { reference: :weaponsroom,
          name: "Weapons Room",
          desc: "A room full of weapons. There's a door to the east.",
          paths: { east: :broomcloset, west: :gateway },
          items: {sword: "a long, chipped sword",
                  axe: "a heavy battleaxe, stained with red",
                  staff: "A big gnarly stick. Maybe it belonged to a wizard!"},
          actions: { }
        },

        { reference: :broomcloset,
          name: "Broom Closet",
          desc: "a small room with brooms",
          paths: { west: :weaponsroom },
          items: { broom: "a fine straw broom",
                   mop: "a dirty old mop" },
          actions: { }
        },


        { reference: :blockedgate,
          name: "Blocked Gate",
          desc: "the gate is locked",
          paths: { north: :gateway },
          items: { },
          actions: { }
        },

        { reference: :tearoom,
          name: "Tea Room",
          desc: "A tea party room! yay!",
          paths: { east: :gateway },
          items: {tea: "Earl Grey. Nice.", teacup: "delicate and fine"},
          actions: {smash: "You smash one of the teacups. Why would you do that? Luckily there are some more."}
        }

      ]
  #
  # mm_items = [
  #   { reference:
  #     name:
  #     desc:
  #     actions:
  #   }
  #
  # ]

  cave_items = [
    { reference: :gold,
      name: "gold",
      desc: "a few sparkling nuggest of gold",
      actions: { }
    },

    { reference: :silver,
      name: "silver",
      desc: "three tarnished silver coins",
      actions: { }
    }
  ]

  caves = [
      { reference: :largecave,
        name: "Large Cave",
        desc: "a large, cavernous cave",
        paths: { west: :smallcave },
        items: cave_items,
        actions: { }
      },

      { reference: :smallcave,
        name: "Small Cave",
        desc: "a small, claustrophobic cave",
        paths: { east: :largecave },
        items: [ ],
        actions: { }
      }
    ]



  {minotaur_mansion: minotaur_mansion, caves: caves}

  end
end
