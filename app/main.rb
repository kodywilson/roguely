# Roguelike game
require 'app/game.rb'
require 'app/controllers/title.rb'

def tick(args)
  $game ||= Game.new
  $game.tick(args)
end
