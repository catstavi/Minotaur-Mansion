# This file is to require all of our dependencies (each of the classes we make)
require 'engtagger'

require_relative "advgame/parser.rb"
require_relative "advgame/createamap.rb"
require_relative "advgame/cavemap.rb"
require_relative "advgame/action.rb"
require_relative "advgame/item.rb"
require_relative "advgame/room.rb"
require_relative "advgame/player.rb"
require_relative "advgame/dungeon.rb"
require_relative "advgame/playgame.rb"


thisgame = AdvGame::GameEngine.new
thisgame.play
