# This file is to require all of our dependencies (each of the classes we make)
require_relative "advgame/createamap.rb"
require_relative "advgame/cavemap.rb"
require_relative "advgame/dungeon.rb"
require_relative "advgame/playgame.rb"


thisgame = GameEngine.new
thisgame.play
