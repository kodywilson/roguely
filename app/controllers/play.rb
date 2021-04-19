# Set up and manage title screen
module Controllers
  class Play
    def self.tick(args)
    end

    def self.render(state, sprites, labels)
      sprites << state.map.tiles
    end

    def self.reset(state)
      Controllers::Map.load_map(state)
    end
  end
end
