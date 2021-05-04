# Roguely Game Window

SPRITES = File.join(GAME_ROOT, 'assets/sprites')
TEXT = File.join(GAME_ROOT, 'assets/text')

require 'gosu'
require_relative 'player'
require_relative 'scroll_text'

class Roguely < Gosu::Window

  WIDTH = 1024
  HEIGHT = 768

  def initialize
    super(WIDTH,HEIGHT)
		self.caption = 'Roguely'
    @scene = :start
		@start_font = Gosu::Font.new(28)
		@top_font = Gosu::Font.new(64)
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
    @scene = :game
    @enemies_appeared = 0
    @enemies_destroyed = 0
    # @game_music = Gosu::Song.new('sounds/Cephalopod.ogg')
    # @game_music.play(true)
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
		if button_down?(Gosu::KbLeft) || button_down?(Gosu::KbA)
			@player.direction = :left
			@player.moving = true
		elsif button_down?(Gosu::KbRight) || button_down?(Gosu::KbD)
    	@player.direction = :right
			@player.moving = true
    elsif button_down?(Gosu::KbUp) || button_down?(Gosu::KbW)
			@player.direction = :up
			@player.moving = true
		elsif button_down?(Gosu::KbDown) || button_down?(Gosu::KbS)
			@player.direction = :down
			@player.moving = true
		else
		 	@player.moving = false
		end
    @player.move
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
	end

	def draw_start
		clip_to(50,140,1250,480) do
      @intro.each { |intro| intro.draw }
			@player.draw_start
    end
		3.times {|x| draw_line(0,138 + x,Gosu::Color::RED,WIDTH,138 + x,Gosu::Color::RED)}
    @top_font.draw_text(@top_message,400,40,1,1,1,Gosu::Color::RED)
		3.times {|x| draw_line(0,628 + x,Gosu::Color::RED,WIDTH,628 + x,Gosu::Color::RED)}
    @start_font.draw_text(@bottom_message,180,660,1,1,1,Gosu::Color::AQUA)
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
