# Entities that move around
module Entities
  class Mobile < Base
    def self.spawn(tile_x, tile_y)
      new(
        x: tile_x * SPRITE_WIDTH,
        y: tile_y * SPRITE_HEIGHT
      )
    end
  end
end

