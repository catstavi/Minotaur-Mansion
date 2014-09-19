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

  def status_set
      {:healthy => "strong and healthy",
      :hurt => "You are pained.",
      :hungry => "Your stomach rumbles.",
      :tired => "You're exhausted."}
  end

  def player_hash
    { :inventory => items[:inventory],
      :status_set => status_set,
      :starter_status => status_set[:healthy]
      }
  end

  def actions
     { :hole => [
      { reference: :jump,
        desc: "You leap into the pitch black hole. Your leg twists painfully under you.",
        path: :darkpit,
        status_change: :hurt,
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
          :special_check => :holding_this,
          fail_desc: "You're not holding any gold." }
        ],

      :hat => [
        {reference: :wear,
        desc: "You put on the hat. Looks good.",
        special_check: :holding_this,
        fail_desc: "You can't put on what you don't have."}
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
        takeable: false }
      ],

      :smallcave => [
        { reference: :silver,
          name: "silver",
          desc: "a few tarnished silver coins",
          actions: actions[:silver],
          takeable: true }
      ],

      :darkpit => [
        { reference: :wall,
          name: "the wall",
          desc: "a steep sloping wall",
          actions: actions[:wall],
          takeable: false }
      ],

      :inventory => [
        { reference: :hat,
        name: "hat",
        desc: "a knitted hat your mother made you.",
        actions: actions[:hat],
        takeable: true }
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
