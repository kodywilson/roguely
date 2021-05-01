module Entities
  class Zombie < Enemy
    def initialize(opts = {})
      super
      @path = 'sprites/zombie_idle_anim_f0.png'
    end
  end
end
