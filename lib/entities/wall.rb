# Wall tiles

class Wall < Terrain

  def initialize(window, x, y)
    super
    @z = 1
    @image = Gosu::Image.new(File.join(SPRITES, 'tile', 'wall.png'), { tileable: true })
  end

end
