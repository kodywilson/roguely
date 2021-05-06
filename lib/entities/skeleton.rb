# Skeletons!

class Skeleton

  SKEL_LOC = File.join(SPRITES, 'npc', 'skeleton')

  attr_reader :x, :y, :radius, :width, :height, :b_left, :b_right, :b_top, :b_low

  def initialize(window, x, y)
    @window = window
    @x = x
    @y = y
    @z = 2
    @radius = 16 # Trying this with my 32 pixel tiles
    @scale = 1
    @frames = Gosu::Image.load_tiles(File.join(SKEL_LOC, "skeleton_walk.png"), 22, 33)
    # bounding variables
    @image_index = 0
    @finished = false
    @counter = 0
    @width = 23
    @height = 33
    @b_left = @x
    @b_right = @x + @width
    @b_top = @y
    @b_low = @y + @height
  end

  def draw
    if @image_index < @frames.count
      @frames[@image_index].draw(@x, @y, 2, scale_x = @scale, scale_y = @scale)
      if @counter % 10 == 0
        @image_index += 1
      end
      @counter += 1
    else
      @finished = true
      @image_index = 0
      counter = 0
    end
    #@frames[1].draw(@x, @y, 2, scale_x = @scale, scale_y = @scale)
  end

end

