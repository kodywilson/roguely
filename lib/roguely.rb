# Roguely Game Window

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
		@bottom_message = "Press space to begin the game."
		@intro = []
    y = 700
    File.open('assets/text/intro.txt').each do |line|
      @intro.push(ScrollText.new(self,line.chomp,100,y))
      y += 30
    end
		@player = Player.new(self,700,300)
  end

	def update_start
		@intro.each { |intro| intro.move }
    @intro.each { |intro| intro.reset } if @intro.last.y < 150
	end

  def update
  	case @scene
		when :start
			update_start
		end
  end

	def draw_start
		clip_to(50,139,1250,480) do
      @intro.each { |intro| intro.draw }
			@player.draw_start
    end
		draw_line(0,140,Gosu::Color::RED,WIDTH,140,Gosu::Color::RED)
    @top_font.draw_text(@top_message,400,40,1,1,1,Gosu::Color::RED)
    draw_line(0,628,Gosu::Color::RED,WIDTH,628,Gosu::Color::RED)
    @start_font.draw_text(@bottom_message,180,660,1,1,1,Gosu::Color::AQUA)
	end

  def draw
    case @scene
    when :start
      draw_start
    end
  end
    
end