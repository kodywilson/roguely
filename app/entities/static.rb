# Entities that don't shift much
module Entities
  class Static < Base
    def tick(args)
      @x = map_x - args.state.map.x
      @y = map_y - args.state.map.y
    end
  end
end

