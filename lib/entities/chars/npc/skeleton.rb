# Skeletons!

class Skeleton < Char

  SKEL_LOC = File.join(SPRITES, 'npc', 'skeleton')

  @@enemies_appeared ||= 0

  def initialize(window, x, y)
    super
    @images = load_images
    @frames = @images[:walk_left]
    @mode = window.mode
    @width = 23
    @height = 33
    @@enemies_appeared += 1
    @velocity = 1
    @current_health = @mode == :normal ? 10.00 : 20.00
    @max_health =  @mode == :normal ? 10.00 : 20.00
    # bounding variables
    @b_left = @x
    @b_right = @x + @width
    @b_top = @y
    @b_low = @y + @height
  end

  def animation
    case @direction
    when :left
      @frames = @images[:walk_left]
      @frames = @images[:attack_left] if @attacking == true
    when :right
      @frames = @images[:walk_right]
      @frames = @images[:attack_right] if @attacking == true
    end
  end

  def attack
    @attacking = true
    @hit_timer = Gosu.milliseconds + 2000
    max_hit = @mode == :normal ? 3 : 5
    damage = 0
    damage = rand(1..max_hit) if rand(1..10) > 6
    return damage
  end

  def load_images
    {
      walk_right: Gosu::Image.load_tiles(File.join(SKEL_LOC, "skeleton_walk.png"), 22, 33),
      walk_left: Gosu::Image.load_tiles(File.join(SKEL_LOC, "skeleton_walk_left.png"), 22, 33),
      #idle: Gosu::Image.load_tiles(File.join(IMAGE_LOC, "idle", "warrior_idle.png"), 128, 88),
      attack_right: Gosu::Image.load_tiles(File.join(SKEL_LOC, "skeleton_attack.png"), 43, 37),
      attack_left: Gosu::Image.load_tiles(File.join(SKEL_LOC, "skeleton_attack_left.png"), 43, 37)
    }
  end

  def move(direction)
    @direction = direction
    case direction
    when :left
      @x -= @velocity
    when :right
      @x += @velocity
    when :up
      @y -= @velocity
    when :down
      @y += @velocity
    when :nowhere
      # Don't do anything
    end
  end

  def update_bounds
    @b_left = @x
    @b_right = @x + @width
    @b_top = @y
    @b_low = @y + @height
    # @b_left = @x + @width / 4
    # @b_right = @x + @width * 3 / 4
    # @b_top = @y + 2
    # @b_low = @y + @height
  end

  def draw
    # Health Bar
    bar_x = @current_health >= 1 ? @current_health / @max_health : 0
    Gosu::draw_line(@b_left,@b_top,@color,@b_left + @width * bar_x, @b_top,@color,2) unless @intro
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
      @font.draw_text("Enemies appeared: #{@@enemies_appeared}",180,690,1,1,1,@color)
    end
    #@frames[1].draw(@x, @y, 2, scale_x = @scale, scale_y = @scale)
  end

end

