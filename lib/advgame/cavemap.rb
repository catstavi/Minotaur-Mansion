#actions returns a hash
#keys are items, the value of the key is an array of actions to be loaded into that
#item's action attribute as Action objects
class CaveMap < Map
  # set_rooms(rooms)
  attr_accessor :room_array

  def initialize
    @room_array = rooms
    super
  end

  def actions
     { :hole => [
      { reference: :jump,
        desc: "You leap into the pitch black hole. Your leg twists painfully under you.",
        path: :darkpit,
        status_change: "pained. Your leg throbs dully.",
        #special_check:,
        fail_desc: nil }
      ],

      :wall => [
      { reference: :climb,
        desc: "You scramble frantically back up the wall.",
        path: :largecave,
        status_change: nil,
        #special_check:,
        fail_desc: nil },
      ],

      :gold => [
       { reference: :smoosh,
          desc: "You smoosh the soft, smooshable gold",
          #path: ,
          #status_change: ,
          #:special_check => (@player.inventory.keys.include? :gold),
          fail_desc: "There's no gold for you to smoosh." }
        ]
      }
  end

      # how to do a special check about inventory?

  #items method returns a hash. the keys are room references. The value to each key
  # is an array filled with items to be loaded into the items attribute of the room,
  # as objects
  def items
    { :largecave => [
      { reference: :gold,
        name: "gold",
        desc: "a few sparkling nuggets of gold",
        actions: actions[:gold],
        takeable: true },

      { reference: :hole,
        name: "hole",
        desc: "a deep, black hole. There are probably sharp rocks down there.",
        actions: actions[:hole],
        takeable: false}
      ],

      :smallcave => [
        { reference: :silver,
          name: "silver",
          desc: "three tarnished silver coins",
          actions: actions[:silver],
          takeable: true }
      ],

      :darkpit => [
        { reference: :wall,
          name: "the wall",
          desc: "a steep sloping wall",
          actions: actions[:wall],
          takeable: false}
      ]
    }

  end

  def rooms
    [
        { reference: :largecave,
          name: "Large Cave",
          desc: "a large, cavernous cave, with a hole",
          paths: { west: :smallcave },
          items: items[:largecave]
          },

        { reference: :smallcave,
          name: "Small Cave",
          desc: "a small, claustrophobic cave",
          paths: { east: :largecave },
          items: items[:smallcave]
          },

        { reference: :darkpit,
          name: "Dark Pit",
          desc: "it's dark and the wall press in around you",
          paths: { },
          items: items[:darkpit]
          }

      ]
  end

end
