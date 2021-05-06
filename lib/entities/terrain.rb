# Base class for terrain tiles and objects
# Other than doors,these generally do not move.

class Terrain

  attr_reader :x, :y, :middle, :radius

  def initialize(window, x, y)
    @window = window
    @x = x
    @y = y
    @z = 0
    @radius = 16 # Trying this with my 32 pixel tiles
    @middle = [@x + @radius, @y + @radius]
    @scale = 2
    @image = Gosu::Image.new(File.join(SPRITES, 'tile', 'floor.png'), { tileable: true })
  end

  def draw
    @image.draw(@x, @y, @z, scale_x = @scale, scale_y = @scale)
  end

end
