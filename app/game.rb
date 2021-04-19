# Create and manage game
class Game
  attr_reader :active_controller

  def goto_title
    @active_controller = Controllers::Title
  end

  def goto_game(args)
    Controllers::Play.reset(args.state)
    @active_controller = Controllers::Play
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
  end
end

