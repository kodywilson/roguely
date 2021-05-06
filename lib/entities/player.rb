# Player sprite class
class Player

  ACCELERATION = 1
  FRICTION = 0.5
  IMAGE_LOC = File.join(SPRITES, 'pc', 'warrior_fem')
  MAX_SPEED = 6

  attr_reader :x, :y, :angle, :radius, :height, :width
  attr_accessor :colliding, :direction, :middle, :moving, :velocity

  def initialize(window, x, y)
    @x = x
    @y = y
    @angle = 0.0
    @direction = :left
    @moving = false
    @velocity = 3
    @velocity_x = 0
    @velocity_y = 0
    @radius = 8
    @middle = []
    @colliding = false
    @window = window
    @image_index = 0
    @finished = false
    @counter = 0
    @font = Gosu::Font.new(28)
    @images = load_images
    @frames = @images[:idle][0..5]
    @height = @frames[0].height / 2
    @width = @frames[0].width / 2
    @color = Gosu::Color::RED
    # bounding variables
    @b_left = @x + @width / 4
    @b_right = @x + @width * 3 / 4
    @b_top = @y + @height / 8
    @b_low = @y + @height
  end

  def accelerate
    @velocity_x += Gosu.offset_x(@angle, ACCELERATION)
    @velocity_y += Gosu.offset_y(@angle, ACCELERATION)
  end
  
  def load_images
    {
      running: Gosu::Image.load_tiles(File.join(IMAGE_LOC, "run", "warrior_run_x2.png"), 128, 88),
      idle: Gosu::Image.load_tiles(File.join(IMAGE_LOC, "idle", "warrior_idle.png"), 128, 88),
      attack: Gosu::Image.load_tiles(File.join(IMAGE_LOC, "attack", "warrior_attack.png"), 128, 88)
    }
  end

  def move
    @velocity = MAX_SPEED if @velocity > MAX_SPEED
    case @direction
    when :left
      if @moving == true
        @x -= @velocity
        @frames = @images[:running][0..7]
      else
        @frames = @images[:idle][0..5]
      end
    when :right
      if @moving == true
        @x += @velocity
        @frames = @images[:running][8..15]
      else
        @frames = @images[:idle][6..11]
      end
    when :up
      @y -= @velocity if @moving == true
      #@frames = @images[:idle][0..5]
    when :down
      @y += @velocity if @moving == true
      #@frames = @images[:idle][6..11]
    end
    #@velocity = 5 if @moving == false
    # @x += @velocity_x
    # @y += @velocity_y
    # @velocity_x *= FRICTION
    # @velocity_y *= FRICTION
    # if @x > @window.width - @radius
    #   @velocity = 1
    #   @x = @window.width - @radius
    # end
    # if @x < @radius
    #   @velocity = 1
    #   @x = @radius
    # end
    # if @y > @window.height - @radius
    #   @velocity = 1
    #   @y = @window.height - @radius
    # end
  end

  def draw(scale = 0.5)
    #scale = 1
    if @image_index < @frames.count
      @frames[@image_index].draw(@x, @y, 2, scale_x = scale, scale_y = scale)
      if @counter % 5 == 0
        @image_index += 1
      end
      @counter += 1
    else
      @finished = true
      @image_index = 0
      counter = 0
    end
    #@start_font.draw_text("Height: #{@player.height.to_s}  Width: #{@player.width.to_s}",180,660,1,1,1,Gosu::Color::RED)
		if DEBUG
      # Draw cross centered on player
      Gosu::draw_line(@x + @width / 2,@y,@color,@x + @width / 2,@y + @height,@color,2)
      Gosu::draw_line(@x,@y + @height / 2,@color,@x + @width,@y + @height / 2,@color,2)
      # Draw box around player - quads are solid so better to use lines
      #.draw_quad(x1, y1, c1, x2, y2, c2, x3, y3, c3, x4, y4, c4, z = 0, mode = :default)
      #Gosu::draw_quad(@x + @width / 4, @y + @height / 4, @color, @x + @width * 3 / 4, @y + @height / 4, @color, @x + @width * 3 / 4, @y + @height * 3 / 4, @color, @x, @y + @height * 3 / 4, @color, 3)
      # Scaling really makes this more funky - here's a bpx using the width and height
      # Gosu::draw_line(@x,@y,@color,@x + @width,@y,@color,2)
      # Gosu::draw_line(@x + @width,@y,@color,@x + @width,@y + @height,@color,2)
      # Gosu::draw_line(@x,@y,@color,@x,@y + @height,@color,2)
      # Gosu::draw_line(@x,@y + height,@color,@x + @width,@y + @height,@color,2)
      # and now one that represents the player's bounds box
      Gosu::draw_line(@b_left,@b_top,@color,@b_right,@b_top,@color,2)
      Gosu::draw_line(@b_right,@b_top,@color,@b_right,@b_low,@color,2)
      Gosu::draw_line(@b_left,@b_top,@color,@b_left,@b_low,@color,2)
      Gosu::draw_line(@b_left,@b_low,@color,@b_right,@b_low,@color,2)
    end
  end

  def draw_start
    @frames = @images[:running][0..7] + @images[:idle][0..5] + @images[:attack][0..11]  + @images[:running][8..15] + @images[:idle][6..11] + @images[:attack][12..23]
    draw(2)
  end

  def update_bounds
    @b_left = @x + @width / 4
    @b_right = @x + @width * 3 / 4
    @b_top = @y + @height / 8
    @b_low = @y + @height
  end

end
