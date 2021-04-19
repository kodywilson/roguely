# Walls!
module Entities
  class Wall < Static

    def initialize(opts = {})
      super
      @path = 'sprites/wall.png'
  end
end

