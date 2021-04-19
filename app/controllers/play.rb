# Set up and manage title screen
module Controllers
  class Play
    def self.tick(args)
      args.state.player.tick(args)
    end

    def self.render(state, sprites, labels)
      sprites << state.map.tiles
      sprites << state.player
    end

    def self.reset(state)
      Controllers::Map.load_map(state)
      state.player = Entities::Player.spawn(2, 2)
    end
  end
end
