# Roguelike game
require 'app/game.rb'
require 'app/controllers/title.rb'
require 'app/controllers/play.rb'
require 'entities/base.rb'
require 'entities/static.rb'

def tick(args)
  $game ||= Game.new
  $game.tick(args)
end
