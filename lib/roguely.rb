# Roguely Game Window

DEBUG = false # set to false to turn off bounding boxes etc.
FONT = File.join(GAME_ROOT, 'assets', 'fonts', 'dragonfly.ttf')
SPRITES = File.join(GAME_ROOT, 'assets/sprites')
TEXT = File.join(GAME_ROOT, 'assets/text')

require 'gosu'
require_relative 'entities/player'
require_relative 'entities/scroll_text'
require_relative 'entities/terrain'
require_relative 'entities/wall'
require_relative 'entities/skeleton'

class Roguely < Gosu::Window

  WIDTH = 1024
  HEIGHT = 768

  def initialize
    super(WIDTH,HEIGHT)
		self.caption = 'Roguely'
    @scene = :start
		@start_font = Gosu::Font.new(32, { name: FONT })
		@top_font = Gosu::Font.new(64, { name: FONT })
		@top_message = "Roguely"
		@bottom_message = "Press < space > to begin the game, < q > to quit."
		@intro = []
    y = 700
    File.open(File.join(TEXT, 'intro.txt')).each do |line|
      @intro.push(ScrollText.new(self,line.chomp,100,y))
      y += 30
    end
		@player = Player.new(self,680,280)
  end

	def initialize_game
    @player = Player.new(self,100,600)
    @enemies = []
		@floor = []
		@wall = []
		lay_tile
    @scene = :game
    @enemies_appeared = 0
    @enemies_destroyed = 0
    # @game_music = Gosu::Song.new('sounds/Cephalopod.ogg')
    # @game_music.play(true)
  end

	def colliding?(direction)
		ents = @wall + @enemies
		case direction
		when :left
			(ents.select {|ent| ent.b_right < @player.b_left}).each do |ent|
				ent.height.times do |ent_y|
					next unless ent_y % 2 == 0
					@player.height.times do |play_y|
						next unless play_y % 2 == 0
						distance = Gosu.distance(ent.b_right, ent.b_top + ent_y, @player.b_left, @player.y + play_y)
						return true if distance < 4
					end
				end
			end
		when :right
			(ents.select {|ent| ent.b_left > @player.b_right}).each do |ent|
				ent.height.times do |ent_y|
					next unless ent_y % 2 == 0
					@player.height.times do |play_y|
						next unless play_y % 2 == 0
						distance = Gosu.distance(ent.b_left, ent.b_top + ent_y, @player.b_right, @player.y + play_y)
						return true if distance < 4
					end
				end
			end
		when :up
			(ents.select {|ent| ent.b_low > @player.b_top}).each do |ent|
				ent.height.times do |ent_x|
					next unless ent_x % 4 == 0
					@player.height.times do |play_x|
						next unless play_x % 4 == 0
						distance = Gosu.distance(ent.b_left + ent_x, ent.b_low, @player.b_left + play_x, @player.b_top)
						return true if distance < 4
					end
				end
			end
		when :down
			(ents.select {|ent| ent.b_top > @player.b_low}).each do |ent|
				ent.height.times do |ent_x|
					next unless ent_x % 4 == 0
					@player.height.times do |play_x|
						next unless play_x % 4 == 0
						distance = Gosu.distance(ent.b_left + ent_x, ent.b_top, @player.b_left + play_x, @player.b_low)
						return true if distance < 4
					end
				end
			end
		end
	end

	def lay_tile # Har har
		# First set out floor tiles
		x, y = 32, 32
		23.times do |a|
			31.times do |b|
				@floor.push(Terrain.new(self,x,y))
				x = 32 * (b + 1)
			end
			x = 32
			y = 32 * (a + 1)
		end
		#Second build walls
		x, y = 0, 0
		2.times do
			33.times do |b|
				@wall.push(Wall.new(self,x,y))
				x = 32 * b
			end
			y = HEIGHT - 32
		end
		x, y = 0, 0
		2.times do
			25.times do |b|
				@wall.push(Wall.new(self,x,y))
				y = 32 * b
			end
			x = WIDTH - 32
		end
		# Third, randomly distribute some wall pieces around the map
		@x = rand * 640
    @y = rand * 480
		20.times { @wall.push(Wall.new(self,rand(32..WIDTH - 64),rand(32..HEIGHT - 64))) }
		# Fourth and this will be moved later, spawn some enemies.
		10.times { @enemies.push(Skeleton.new(self,rand(32..WIDTH - 64),rand(32..HEIGHT - 64))) }
	end

  def needs_cursor?
    false
  end

  def button_down_game(id)
		# use later for shooting arrows
    # if id == Gosu::KbSpace
    #   @arrows.push(Bullet.new(self, @player.x, @player.y, @player.angle))
    #   @shooting_sound.play(0.3)
    # end
		if id == Gosu::KbEscape
			initialize
		end
		if id == Gosu::KbLeftShift # Toggle sprinting
			if @player.velocity == 3
				@player.velocity = 6
			else
				@player.velocity = 3
			end
		end
  end

  def button_down_start(id)
		# start and end are the same now, but eventually you will have more options
    initialize_game if id == Gosu::KbSpace
    close if id == Gosu::KbQ
  end

  def button_down_end(id)
    initialize_game if id == Gosu::KbSpace
    close if id == Gosu::KbQ
  end

  def button_down(id)
		# Keys do different things depending on scene
    case @scene
    when :start
      button_down_start(id)
    when :game
      button_down_game(id)
    when :end
      button_down_end(id)
    end
  end

	def update_game
		if button_down?(Gosu::KbLeft) || button_down?(Gosu::KbA) || button_down?(Gosu::KbRight) || button_down?(Gosu::KbD) || button_down?(Gosu::KbUp) || button_down?(Gosu::KbW) || button_down?(Gosu::KbDown) || button_down?(Gosu::KbS)
			@player.moving = true
			# Although it is more realistic, I'm not convinced that I like the "feel" of acceleration. It ends up feeling "sticky"...
			# using gosu offset might feel smoother.
			#@player.velocity += 1 if Gosu.milliseconds % 10 == 0
			#@player.velocity = 5
			@player.direction = :left if button_down?(Gosu::KbLeft) || button_down?(Gosu::KbA)
    	@player.direction = :right if button_down?(Gosu::KbRight) || button_down?(Gosu::KbD)
			@player.direction = :up if button_down?(Gosu::KbUp) || button_down?(Gosu::KbW)
			@player.direction = :down if button_down?(Gosu::KbDown) || button_down?(Gosu::KbS)
		else
		 	@player.moving = false
			#@player.velocity = 5
		end
		@player.update_bounds
		#@player.velocity = 10 if button_down?(Gosu::KbLeftShift)# || button_down?(Gosu::KbA)
		@colliding = colliding?(@player.direction)
    @player.move unless @colliding == true
	end

	def update_start
		@intro.each { |intro| intro.move }
    @intro.each { |intro| intro.reset } if @intro.last.y < 150
	end

  def update
  	case @scene
		when :start
			update_start
		when :game
			update_game
		end
  end

	def draw_game
		@player.draw
		@floor.each { |floor| floor.draw }
		@wall.each { |wall| wall.draw }
		@enemies.each {|enemy| enemy.draw }
	end

	def draw_start
		clip_to(50,140,1250,480) do
      @intro.each { |intro| intro.draw }
			@player.draw_start
    end
		draw_line(80,138,Gosu::Color::RED,90,128,Gosu::Color::RED)
		draw_line(100,138,Gosu::Color::RED,90,128,Gosu::Color::RED)
		draw_line(WIDTH - 160,138,Gosu::Color::RED,WIDTH - 175,158,Gosu::Color::RED)
		draw_line(WIDTH - 190,138,Gosu::Color::RED,WIDTH - 175,158,Gosu::Color::RED)
		3.times {|x| draw_line(0,138 + x,Gosu::Color::RED,WIDTH,138 + x,Gosu::Color::RED)}
    @top_font.draw_text(@top_message,400,40,1,1,1,Gosu::Color::RED)
		3.times {|x| draw_line(0,628 + x,Gosu::Color::RED,WIDTH,628 + x,Gosu::Color::RED)}
    @start_font.draw_text(@bottom_message,180,660,1,1,1,Gosu::Color::RED)
	end

  def draw
    case @scene
    when :start
      draw_start
		when :game
			draw_game
		end
  end
    
end
