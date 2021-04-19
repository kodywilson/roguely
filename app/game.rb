# Create and manage game
class Game
  attr_reader :active_controller

  def goto_title
    @active_controller = Controllers::Title
  end

  def tick(args)
    goto_title unless active_controller
    sprites = []
    labels = []
    active_controller.tick(args)
    active_controller.render(args.state, sprites, labels)
    render(args, sprites, labels)
  end

  def render(args, sprites, labels)
    args.outputs.sprites << sprites
    args.outputs.labels << labels
    args.outputs.solids << [0, 240, 1440, 10, 100, 200, 100, 255]
  end
end

