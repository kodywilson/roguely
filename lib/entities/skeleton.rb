# Skeletons!

class Skeleton

  SKEL_LOC = File.join(SPRITES, 'npc', 'skeleton')

  attr_reader :x, :y, :radius, :width, :height, :b_left, :b_right, :b_top, :b_low
  attr_accessor :attacking

  @@enemies_appeared ||= 0

  def initialize(window, x, y)
    @window = window
    @x = x
    @y = y
    @z = 2
    @radius = 16 # Trying this with my 32 pixel tiles
    @scale = 1
    @font = Gosu::Font.new(28)
    @images = load_images
    @frames = @images[:walk]
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
    @attacking = false
    @@enemies_appeared += 1
  end

  def animation
    @frames = @images[:walk]
    @frames = @images[:attack] if @attacking == true
  end

  def attack
    @attacking = true
  end

  def load_images
    {
      walk: Gosu::Image.load_tiles(File.join(SKEL_LOC, "skeleton_walk.png"), 22, 33),
      #idle: Gosu::Image.load_tiles(File.join(IMAGE_LOC, "idle", "warrior_idle.png"), 128, 88),
      attack: Gosu::Image.load_tiles(File.join(SKEL_LOC, "skeleton_attack.png"), 43, 37)
    }
  end

  def draw
    if @image_index < @frames.count
      @frames[@image_index].draw(@x, @y, 2, scale_x = @scale, scale_y = @scale)
      if @counter % 3 == 0
        @image_index += 1
      end
      @counter += 1
    else
      @finished = true
      @attacking = false
      @image_index = 0
      counter = 0
    end
    if DEBUG
      @font.draw_text("Enemies appeared: #{@@enemies_appeared}",180,690,1,1,1,Gosu::Color::RED)
    end
    #@frames[1].draw(@x, @y, 2, scale_x = @scale, scale_y = @scale)
  end

end

