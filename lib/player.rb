# Player sprite class
class Player

  ROTATION_SPEED = 3 # These should be an instance variable based on chosen difficulty
  ACCELERATION = 1
  FRICTION = 0.9
  IMAGE_LOC = File.join(SPRITES, 'pc', 'warrior_fem')

  attr_reader :x, :y, :angle, :radius

  def initialize(window, x, y)
    @x = x
    @y = y
    @angle = 0.0
    @velocity_x = 0
    @velocity_y = 0
    @radius = 30
    @window = window
    #@images = Gosu::Image.load_tiles('assets/sprites/adventurer-v1.5-Sheet.png', 50, 37)
    @image_index = 0
    @finished = false
    @counter = 0
    @font = Gosu::Font.new(28)
    @images = load_images
  end

  def accelerate
    @velocity_x += Gosu.offset_x(@angle, ACCELERATION)
    @velocity_y += Gosu.offset_y(@angle, ACCELERATION)
  end
  
  def load_images
    {
      running: Gosu::Image.load_tiles(File.join(IMAGE_LOC, "run", "warrior_run_x2.png"), 128, 88)
    }
  end

  def move
    @x += @velocity_x
    @y += @velocity_y
    @velocity_x *= FRICTION
    @velocity_y *= FRICTION
    if @x > @window.width - @radius
      @velocity_x = 0
      @x = @window.width - @radius
    end
    if @x < @radius
      @velocity_x = 0
      @x = @radius
    end
    if @y > @window.height - @radius
      @velocity_y = 0
      @y = @window.height - @radius
    end
  end

  def turn_right
    @angle += ROTATION_SPEED
  end

  def turn_left
    @angle -= ROTATION_SPEED
  end

  # def draw
  #   @image.draw_rot(@x, @y, 1, @angle)
  # end

  def draw_start
    if @image_index < @images[:running].count
      @images[:running][@image_index].draw(@x, @y, 1, scale_x = 2, scale_y = 2)
      if @counter % 5 == 0
        @image_index += 1
      end
      @counter += 1
    else
      @finished = true
      @image_index = 0
      counter = 0
      if @angle == 0.0
        @angle = 0.0
      else
        @angle = 0.0
      end
    end
  end

end
