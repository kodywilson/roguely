# Base class for terrain tiles and objects
# Other than doors,these generally do not move.

class Terrain

  attr_reader :x, :y, :middle, :radius, :width, :height, :b_left, :b_right, :b_top, :b_low

  def initialize(window, x, y)
    @window = window
    @x = x
    @y = y
    @z = 0
    @radius = 16 # Trying this with my 32 pixel tiles
    @scale = 2
    @image = Gosu::Image.new(File.join(SPRITES, 'tile', 'floor.png'), { tileable: true })
    # bounding variables
    @width = 32
    @height = 32
    @b_left = @x
    @b_right = @x + @width
    @b_top = @y
    @b_low = @y + @height
  end

  def draw
    @image.draw(@x, @y, @z, scale_x = @scale, scale_y = @scale)
  end

end
