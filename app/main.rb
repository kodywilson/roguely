# Roguelike game
require 'app/game.rb'

def tick(args)
  $game ||= Game.new
  $game.tick(args)
end
