# Set up and manage title screen
module Controllers
  class Play
    def self.tick(args)
      args.state.player.tick(args)
      Controllers::Enemy.tick(args)
    end

    def self.render(state, sprites, labels)
      sprites << state.map.tiles
      sprites << state.enemies
      sprites << state.player
    end

    def self.reset(state)
      Controllers::Map.load_map(state)
      state.player = Entities::Player.spawn_near(state, 11, 7)
      Controllers::Enemy.spawn_enemies(state)
    end
  end
end
