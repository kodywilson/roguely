# The player!
module Entities
  class Player < Mobile
    def initialize(opts = {})
      super
      @path = 'sprites/pc/elf/elf_f_idle_anim_f0.png'
    end

    def tick(args)
      target_x = if args.inputs.keyboard.key_down.right || args.inputs.keyboard.key_down.d
                   map_x + Controllers::Map::TILE_WIDTH
                 elsif args.inputs.keyboard.key_down.left || args.inputs.keyboard.key_down.a
                   map_x - Controllers::Map::TILE_WIDTH
                 else
                   map_x
                 end
      target_y = if args.inputs.keyboard.key_down.up || args.inputs.keyboard.key_down.w
                   map_y + Controllers::Map::TILE_HEIGHT
                 elsif args.inputs.keyboard.key_down.down || args.inputs.keyboard.key_down.s
                   map_y - Controllers::Map::TILE_HEIGHT
                 else
                   map_y
                 end
      attempt_move(args, target_x, target_y) do
        Controllers::Map.tick(args)
      end
    end
  end
end
