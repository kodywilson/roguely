# Player sprite class
class Player

  ACCELERATION = 1
  FRICTION = 0.5
  IMAGE_LOC = File.join(SPRITES, 'pc', 'warrior_fem')
  MAX_SPEED = 5

  attr_reader :x, :y, :angle, :radius, :height, :width, :b_left, :b_right, :b_top, :b_low, :attacking, :hit_timer
  attr_accessor :colliding, :direction, :intro, :middle, :moving, :velocity, :current_health

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
    @b_top = @y + 2
    @b_low = @y + @height
    @attacking = false
    @current_health = 100.00
    @max_health = 100.00
    @intro = false
    @hit_timer = 0
  end

  def attack(direction)
    case @direction
    when :left
      @frames = @images[:attack][0..11]
    when :up
      @frames = @images[:attack][0..11]
    when :right
      @frames = @images[:attack][12..23]
    when :down
      @frames = @images[:attack][12..23]
    end
    @attacking = true
    @hit_timer = Gosu.milliseconds + 1000
    damage = 0
    damage = rand(1..5) if rand(1..10) > 5
    return damage
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

  def animation
    if @moving == false && @attacking == false
      @frames = @images[:idle][0..5] if @direction == :left || @direction == :up
      @frames = @images[:idle][6..11] if @direction == :right || @direction == :down
    elsif @moving == true && @attacking == false
      case @direction
      when :left || :up
        @frames = @images[:running][0..7]
      when :right || :down
        @frames = @images[:running][8..15]
      end
    end
  end

  def move
    #return if @attacking == true
    @velocity = MAX_SPEED if @velocity > MAX_SPEED
    case @direction
    when :left
      @x -= @velocity
    when :right
      @x += @velocity
    when :up
      @y -= @velocity
    when :down
      @y += @velocity
    end
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
      @attacking = false
      @image_index = 0
      counter = 0
    end
    # Health Bar
    bar_x = @current_health >= 1 ? @current_health / @max_health : 0
    Gosu::draw_line(@b_left,@b_top,@color,@b_left + @width * bar_x, @b_top,@color,2) unless @intro
    #@font.draw_text("Current Health: #{@current_health}",180,690,1,1,1,Gosu::Color::RED)
		if DEBUG
      @font.draw_text("Moving?: #{@moving}  Attacking?: #{@attacking}  Colliding?: #{@colliding}",180,660,1,1,1,@color)
      # Draw cross centered on player
      Gosu::draw_line(@x + @width / 2,@y,@color,@x + @width / 2,@y + @height,@color,2)
      Gosu::draw_line(@x,@y + @height / 2,@color,@x + @width,@y + @height / 2,@color,2)
      # Draw he player's bounds box
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
    @b_top = @y + 2
    @b_low = @y + @height
  end

end
