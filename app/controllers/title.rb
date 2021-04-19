# Set up and manage title screen
module Controllers
  class Title
    def self.tick(args)
      $game.goto_game(args) if args.inputs.keyboard.space
    end

    def self.render(state, sprites, labels)
      labels << [620, 300, 'Roguely']
      labels << [550, 100, 'Press < space bar > to start']
      sprites << [576, 500, 128, 101, 'dragonruby.png']
    end
  end
end
