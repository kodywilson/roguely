module Controllers
  class Enemy
    def self.tick(args)
      return unless args.state.player.took_action
    
      enemies = args.state.enemies
      enemies.each { |enemy| enemy.tick(args) }
    end

    def self.spawn_enemies(state)
      state.enemies ||= []
      30.times do
        tile_x = (::Controllers::Map::MAP_WIDTH * rand).floor
        tile_y = (::Controllers::Map::MAP_HEIGHT * rand).floor
        spawn_enemy(
          state,
          tile_x,
          tile_y,
          ::Entities::Zombie
        )
      end
    end
    
    def self.spawn_enemy(state, tile_x, tile_y, enemy_type)
      state.enemies << enemy_type.spawn_near(
        state,
        tile_x,
        tile_y
      )
    end
  end
end
