# Roguelike game
require 'app/game.rb'

$game ||= Game.new
def tick(args)
  $game.tick(args)
end
