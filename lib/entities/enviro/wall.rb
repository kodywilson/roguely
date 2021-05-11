# Wall tiles

class Wall < Terrain

  def initialize(window, x, y)
    super
    @color = Gosu::Color::RED
    @z = 1
    @image = Gosu::Image.new(File.join(SPRITES, 'tile', 'wall.png'), { tileable: true })
  end

  def draw
    @image.draw(@x, @y, @z, scale_x = @scale, scale_y = @scale)
    if DEBUG
      Gosu::draw_line(@x,@y,@color,@x + 32,@y,@color,2)
      Gosu::draw_line(@x + 32,@y,@color,@x + 32,@y + 32,@color,2)
      Gosu::draw_line(@x,@y,@color,@x,@y + 32,@color,2)
      Gosu::draw_line(@x,@y + 32,@color,@x + 32,@y + 32,@color,2)
    end
  end

end
