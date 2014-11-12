require 'gosu'


class GameWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    self.caption = "Zeta Test"
    @background_image = Gosu::Image.new(self, "village.jpg", true)
    @font = Gosu::Font.new(self, "Arial", 18)

    @player = Player.new(self)
    @player.warp(50, 370)
    @space = false
    @space_cd = 0
  end

  def update
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      @player.walk_left
    end
    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      @player.walk_right
    end
    if button_down? Gosu::KbUp or button_down? Gosu::GpUp then
      @player.walk_up
    end
    if button_down? Gosu::KbDown or button_down? Gosu::GpDown then
      @player.walk_down
    end
    if button_down? Gosu::KbSpace
      if @space_cd <= 0
        @space = true
      end
    end
  end
  def shot_position
    @space_x ||= @player.x + 5
    @space_y ||= @player.y
  end
  def shoot
    @font.draw(">>>---->", @space_x, @space_y, 1, 1, 1)
    @space_x += 10
  end
  def draw
    @player.draw
    @background_image.draw(0, 0, 0)
    @font.draw("#{@player.x}, #{@player.y}", 10, 450, 4, 1.0, 1.0)
    @font.draw("Lap: #{@player.lap}", 10, 420, 4, 1.0, 1.0)
    @font.draw("Shots fired: #{@space} | Time: #{@space_cd}", 10, 390, 4, 1.0, 1.0)
    if @space
      shot_position
      shoot
      if @space_x >= 640
        @space = false
        @space_x = nil
        @space_y = nil
      end
    end
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
end

class Player
  attr_reader :x, :y
  attr_accessor :lap
  def initialize(window)
    @image = Gosu::Image.new(window, "knight1.png", false)
    @lap = 0
  end

  def warp(x, y)
    @x, @y = x, y
  end
  def turn_down
    @y += 4.5
  end
  def walk_up
    if @y > 194.5
      @y -= 4.5
    else
      @y = @y
    end
  end
  def walk_down
    if @y < 397
      @y += 4.5
    else
      @y = @y
    end
  end
  def walk_left
    if @x > -15
      @x -= 4.5
    else
      @x = 640
    end
  end
  def walk_right
    if @x < 630
      @x += 4.5
    else
      self.lap += 1
      @x = -15
    end
  end

  def draw
    @image.draw(@x,@y,3)
  end
end
GameWindow.new.show