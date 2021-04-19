# Roguelike game
require 'app/game.rb'
require 'app/controllers/title.rb'
require 'app/controllers/play.rb'

def tick(args)
  $game ||= Game.new
  $game.tick(args)
end
