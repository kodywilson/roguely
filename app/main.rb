# Roguelike game
require 'app/game.rb'
require 'app/controllers/title.rb'
require 'app/controllers/play.rb'
require 'app/controllers/map.rb'
require 'app/entities/base.rb'
require 'app/entities/static.rb'
require 'app/entities/wall.rb'
require 'app/entities/floor.rb'
require 'app/entities/mobile.rb'
require 'app/entities/player.rb'

def tick(args)
  $game ||= Game.new
  $game.tick(args)
end
