# Enemy base class
module Entities
  class Enemy < Mobile
    def tick(args)
      patrol(args)
      @x = map_x - args.state.map.x
      @y = map_y - args.state.map.y
    end
    
    def patrol(args)
      direction = [:up, :down, :left, :right].sample
      case direction
      when :up
        attempt_move(args, map_x, map_y + ::Controllers::Map::TILE_HEIGHT)
      when :down
        attempt_move(args, map_x, map_y - ::Controllers::Map::TILE_HEIGHT)
      when :left
        attempt_move(args, map_x - ::Controllers::Map::TILE_WIDTH, tile_y)
      when :right
        attempt_move(args, map_x + ::Controllers::Map::TILE_WIDTH, tile_y)
      else
      end
    end
  end
end
