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
		@player.intro = true
  end

	def initialize_game
    @player = Player.new(self,100,600)
		@enemies_appeared = 0
    @enemies_destroyed = 0
    @enemies = []
		@floor = []
		@wall = []
		lay_tile
    @scene = :game
		@slick = 8 # Increase to reduce object collision stickiness
    # @game_music = Gosu::Song.new('sounds/Cephalopod.ogg')
    # @game_music.play(true)
  end

	def colliding?(direction)
		ents = @wall + @enemies
		case direction
		when :left
			(ents.select {|ent| ent.b_right < @player.b_left}).each do |ent|
				ent.height.times do |ent_y|
					next unless ent_y % 2 == 0 && ent_y >= @slick && ent_y <= ent.height - @slick
					@player.height.times do |play_y|
						next unless play_y % 2 == 0 && play_y >= @slick && play_y <= @player.height - @slick
						distance = Gosu.distance(ent.b_right, ent.b_top + ent_y, @player.b_left, @player.y + play_y)
						if distance < 4
							#ent.attacking = true if ent.respond_to? :attacking
							return true
						end
					end
				end
			end
		when :right
			(ents.select {|ent| ent.b_left > @player.b_right}).each do |ent|
				ent.height.times do |ent_y|
					next unless ent_y % 2 == 0 && ent_y >= @slick && ent_y <= ent.height - @slick
					@player.height.times do |play_y|
						next unless play_y % 2 == 0 && play_y >= @slick && play_y <= @player.height - @slick
						distance = Gosu.distance(ent.b_left, ent.b_top + ent_y, @player.b_right, @player.y + play_y)
						if distance < 5
							#ent.attacking = true if ent.respond_to? :attacking
							return true
						end
					end
				end
			end
		when :up
			(ents.select {|ent| ent.b_low > @player.b_top}).each do |ent|
				ent.height.times do |ent_x|
					next unless ent_x % 2 == 0 && ent_x >= @slick && ent_x <= ent.width - @slick
					@player.height.times do |play_x|
						next unless play_x % 2 == 0 && play_x >= @slick && play_x <= @player.width - @slick
						distance = Gosu.distance(ent.b_left + ent_x, ent.b_low, @player.b_left + play_x, @player.b_top)
						if distance < 4
							#ent.attacking = true if ent.respond_to? :attacking
							return true
						end
					end
				end
			end
		when :down
			(ents.select {|ent| ent.b_top > @player.b_low}).each do |ent|
				ent.height.times do |ent_x|
					next unless ent_x % 2 == 0 && ent_x >= @slick && ent_x <= ent.width - @slick
					@player.height.times do |play_x|
						next unless play_x % 2 == 0 && play_x >= @slick && play_x <= @player.width - @slick
						distance = Gosu.distance(ent.b_left + ent_x, ent.b_top, @player.b_left + play_x, @player.b_low)
						if distance < 4
							#ent.attacking = true if ent.respond_to? :attacking
							return true
						end
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
		20.times do
			walls = @wall
			too_close = true
			until too_close == false
				wall_x = rand(32..WIDTH - 64)
				wall_y = rand(32..HEIGHT - 64)
				walls.each do |wall|
					too_close = false if Gosu.distance(wall_x + 16, wall_y + 16, wall.x + 16, wall.y + 16) > 100
					#too_close = false if ( wall_x > wall.x + 32 || wall_x < wall.x - 32 ) && (wall_y > wall.y + 32 || wall_y < wall.y - 32)
				end
			end
			@wall.push(Wall.new(self,wall_x,wall_y))
		end
		# Fourth and this will be moved later, spawn some enemies.
		10.times do
			too_close = true
			until too_close == false
				skel_x = rand(32..WIDTH - 64)
				skel_y = rand(32..HEIGHT - 64)
				@wall.each do |wall|
					too_close = false if ( skel_x > wall.x + 40 || skel_x < wall.x - 40 ) && (skel_y > wall.y + 40 || skel_y < wall.y - 40)
				end
			end
			@enemies.push(Skeleton.new(self,skel_x,skel_y))
			@enemies_appeared += 1
		end
	end

  def needs_cursor?
    false
  end

  def button_down_game(id)
		# use later for shooting arrows
    if id == Gosu::KbSpace
			if @player.attacking == false && @player.hit_timer < Gosu.milliseconds
				@enemies.each do |enemy|
					next if Gosu.distance(@player.x + @player.width / 2, @player.y + @player.height / 2, enemy.x + enemy.width / 2, enemy.y + enemy.height / 2) > 25
					damage_2_enemy = @player.attack(@player.direction)
					enemy.current_health -= damage_2_enemy
				end
			end
    end
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
			@player.direction = :left if button_down?(Gosu::KbLeft) || button_down?(Gosu::KbA)
    	@player.direction = :right if button_down?(Gosu::KbRight) || button_down?(Gosu::KbD)
			@player.direction = :up if button_down?(Gosu::KbUp) || button_down?(Gosu::KbW)
			@player.direction = :down if button_down?(Gosu::KbDown) || button_down?(Gosu::KbS)
		else
		 	@player.moving = false
		end
		@player.update_bounds
		@player.animation
		@colliding = colliding?(@player.direction)
    @player.move unless @colliding == true || @player.attacking == true || @player.moving == false
		@enemies.dup.each do |enemy|
			enemy.update_bounds
			distance = Gosu.distance(enemy.x + enemy.width / 2, enemy.y + enemy.height / 2, @player.x + @player.width / 2, @player.y + @player.height / 2)
			if distance < 70 && distance > 20 # Chase the player!
				target_angle = Gosu.angle(enemy.x + enemy.width / 2, enemy.y + enemy.height / 2, @player.x + @player.width / 2, @player.y + @player.height / 2)
				direction = case
				when target_angle > 225.0 && target_angle < 315.0
					:left
				when target_angle > 45.0 && target_angle < 135.0
					:right
				when ( target_angle > 315.0 && target_angle < 360.0 ) || (target_angle > 0.0 && target_angle < 45.0)
					:up
				when target_angle > 135.0 && target_angle < 225.0
					:down
				end
				enemy.move(direction)
			end
			if distance < 25 && enemy.attacking == false && enemy.hit_timer < Gosu.milliseconds # could adjust based on direction
				damage_2_player = enemy.attack 	
				@player.current_health -= damage_2_player
			end
			enemy.animation
			if enemy.current_health <= 0
				@enemies.delete enemy
				@enemies_destroyed += 1
			end
		end
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
		@start_font.draw_text(@target_angle.to_s,180,560,1,1,1,Gosu::Color::RED)
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
