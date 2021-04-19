# The player!
module Entities
  class Player < Mobile
    def initialize(opts = {})
      super
      @path = 'sprites/player.png'
    end

    def tick(args)
      @y += Controllers::Map::TILE_HEIGHT if args.inputs.keyboard.key_down.up || args.inputs.keyboard.key_down.w
      @y -= Controllers::Map::TILE_HEIGHT if args.inputs.keyboard.key_down.down || args.inputs.keyboard.key_down.s
      @x += Controllers::Map::TILE_HEIGHT if args.inputs.keyboard.key_down.right || args.inputs.keyboard.key_down.d
      @x -= Controllers::Map::TILE_HEIGHT if args.inputs.keyboard.key_down.left || args.inputs.keyboard.key_down.a
    end
  end
end
